import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/bloc/authentication/authentication_bloc.dart';
import '../../../../../core/bloc/authentication/authentication_state.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/teaching_assignment/teaching_assignment_entity.dart';
import '../../../../../domain/entities/user/personnel_entity.dart';
import '../../../common/class_selector/bloc/class_selector_bloc.dart';
import '../../../common/class_selector/bloc/class_selector_state.dart';
import '../../../../widgets/button/app_button.dart';
import '../../../../widgets/dropdown/primary_dropdown.dart';
import '../bloc/personnel_management_bloc.dart';
import '../bloc/personnel_management_event.dart';
import '../bloc/personnel_management_state.dart';

class AssignmentDialog extends StatefulWidget {
  final PersonnelEntity personnel;

  const AssignmentDialog({super.key, required this.personnel});

  @override
  State<AssignmentDialog> createState() => _AssignmentDialogState();
}

class _AssignmentDialogState extends State<AssignmentDialog> {
  final _formKey = GlobalKey<FormState>();

  // SchoolAdmin
  SchoolAdminPositionEnum? _selectedPosition;

  // Teacher assignment - Step 1: Select class
  String? _selectedClassId;
  String? _selectedClassName;

  // Teacher assignment - Step 2: Assignment details (shown after class selection)
  SubjectEnum? _selectedTeachingSubject;
  bool _isMainTeacher = false;
  TeachingAssignmentEntity? _currentAssignment;
  bool _showAssignmentForm = false;

  // Focus nodes
  final _positionFocusNode = FocusNode();
  final _classFocusNode = FocusNode();
  final _subjectFocusNode = FocusNode();

  // Để track trạng thái submit
  bool _isSubmitting = false;
  bool _showSuccessMessage = false;
  bool _isLoadingAssignment = false;

  @override
  void initState() {
    super.initState();

    _selectedPosition = widget.personnel.position;

    _positionFocusNode.addListener(() => setState(() {}));
    _classFocusNode.addListener(() => setState(() {}));
    _subjectFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _positionFocusNode.dispose();
    _classFocusNode.dispose();
    _subjectFocusNode.dispose();
    super.dispose();
  }

  void _onClassSelected(String? classId) {
    if (classId == null) {
      setState(() {
        _selectedClassId = null;
        _selectedClassName = null;
        _showAssignmentForm = false;
        _currentAssignment = null;
        _selectedTeachingSubject = null;
        _isMainTeacher = false;
      });
      return;
    }

    setState(() {
      _selectedClassId = classId;
      _isLoadingAssignment = true;
      _showAssignmentForm = false;
      _currentAssignment = null;
    });

    // Tìm tên lớp để hiển thị
    final classState = context.read<ClassSelectorBloc>().state;
    if (classState is ClassSelectorLoaded) {
      final selectedClass = classState.classes.firstWhere(
        (c) => c.id == classId,
        orElse: () => classState.classes.first,
      );
      _selectedClassName = selectedClass.name;
    }

    // Gọi API tìm phân công của giáo viên với lớp này
    final bloc = context.read<PersonnelManagementBloc>();
    final authState = context.read<AuthenticationBloc>().state;
    if (authState is AuthenticationAuthenticated) {
      bloc.add(
        GetTeachingAssignmentByTeacherClassAndSchoolEvent(
          teacherId: widget.personnel.id!,
          classId: classId,
          schoolId: authState.user.schoolId!,
        ),
      );
    }
  }

  void _submitAssignmentForm() {
    if (_isSubmitting || _selectedClassId == null) return;

    final bloc = context.read<PersonnelManagementBloc>();
    final authState = context.read<AuthenticationBloc>().state;

    if (_formKey.currentState!.validate() &&
        authState is AuthenticationAuthenticated) {
      setState(() {
        _isSubmitting = true;
        _showSuccessMessage = false;
      });

      if (_selectedTeachingSubject != null) {
        final assignment = TeachingAssignmentEntity(
          teacherId: widget.personnel.id!,
          classId: _selectedClassId!,
          schoolId: authState.user.schoolId!,
          subject: _selectedTeachingSubject!,
          isMain: _isMainTeacher,
          id: _currentAssignment?.id,
        );

        if (_currentAssignment != null) {
          bloc.add(UpdateTeachingAssignmentEvent(assignment));
        } else {
          bloc.add(CreateTeachingAssignmentEvent(assignment));
        }
      }
    }
  }

  void _deleteAssignment() {
    if (_currentAssignment != null && !_isSubmitting) {
      setState(() {
        _isSubmitting = true;
        _showSuccessMessage = false;
      });

      context.read<PersonnelManagementBloc>().add(
        DeleteTeachingAssignmentEvent(_currentAssignment!.id!),
      );
    }
  }

  void _submitSchoolAdminPosition() {
    if (_isSubmitting) return;

    final bloc = context.read<PersonnelManagementBloc>();

    if (_formKey.currentState!.validate() && _selectedPosition != null) {
      setState(() {
        _isSubmitting = true;
        _showSuccessMessage = false;
      });

      bloc.add(
        UpdateSchoolAdminPositionEvent(
          personnelId: widget.personnel.id!,
          position: _selectedPosition!,
        ),
      );
    }
  }

  void _closeDialog() {
    if (_isSubmitting) return;

    context.read<PersonnelManagementBloc>().add(HideAssignmentDialogEvent());
    Navigator.of(context).pop();
  }

  void _handleSuccess(String message) {
    setState(() {
      _isSubmitting = false;
      _showSuccessMessage = true;
    });

    // Đợi 1.5 giây để user thấy message success rồi mới đóng dialog
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        context.read<PersonnelManagementBloc>().add(
          HideAssignmentDialogEvent(),
        );
        Navigator.of(context).pop();
      }
    });
  }

  void _handleError() {
    setState(() {
      _isSubmitting = false;
      _showSuccessMessage = false;
    });
  }

  void _handleAssignmentLoaded(TeachingAssignmentEntity? assignment) {
    setState(() {
      _isLoadingAssignment = false;
      _currentAssignment = assignment;
      _showAssignmentForm = true;

      if (assignment != null) {
        // Load existing assignment data
        _selectedTeachingSubject = assignment.subject;
        _isMainTeacher = assignment.isMain;
      } else {
        // Reset for new assignment
        _selectedTeachingSubject = null;
        _isMainTeacher = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PersonnelManagementBloc, PersonnelManagementState>(
      listener: (context, state) {
        if (state is PersonnelManagementLoaded) {
          if (state.assignmentStatus == PersonnelAssignmentStatus.success) {
            if (state.currentTeachingAssignment != null &&
                _isLoadingAssignment) {
              // Load assignment thành công
              _handleAssignmentLoaded(state.currentTeachingAssignment);
            } else if (state.currentTeachingAssignment == null &&
                _isLoadingAssignment) {
              // Không tìm thấy assignment - cho phép tạo mới
              _handleAssignmentLoaded(null);
            } else if (_isSubmitting) {
              // CREATE/UPDATE/DELETE thành công
              String message = 'Cập nhật thành công';
              if (widget.personnel.isSchoolAdmin &&
                  !widget.personnel.isTeacher) {
                message = 'Cập nhật chức vụ thành công';
              } else if (widget.personnel.isTeacher) {
                if (_currentAssignment != null) {
                  message = 'Cập nhật phân công thành công';
                } else {
                  message = 'Tạo phân công thành công';
                }
              }
              _handleSuccess(message);
            }
          } else if (state.assignmentStatus ==
              PersonnelAssignmentStatus.error) {
            setState(() {
              _isLoadingAssignment = false;
            });
            _handleError();
          }
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header với close button
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Phân công - ${widget.personnel.fullName}',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: _isSubmitting ? null : _closeDialog,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Form content
                  Opacity(
                    opacity: _showSuccessMessage ? 0.6 : 1.0,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // School Admin Position
                          if (widget.personnel.isSchoolAdmin) ...[
                            Text(
                              'Chức vụ quản trị',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Focus(
                              focusNode: _positionFocusNode,
                              child: PrimaryDropdown<SchoolAdminPositionEnum>(
                                value: _selectedPosition,
                                hintText: 'Chọn chức vụ',
                                prefixIcon: Icons.admin_panel_settings_outlined,
                                isFocused: _positionFocusNode.hasFocus,
                                items: SchoolAdminPositionEnum.values
                                    .map(
                                      (pos) => DropdownMenuItem(
                                        value: pos,
                                        child: Text(pos.displayName),
                                      ),
                                    )
                                    .toList(),
                                onChanged: _isSubmitting
                                    ? null
                                    : (val) {
                                        setState(() => _selectedPosition = val);
                                      },
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Submit button for school admin position (only if not teacher)
                            if (!widget.personnel.isTeacher) ...[
                              AppButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : _submitSchoolAdminPosition,
                                text: 'Cập nhật chức vụ',
                                loading: _isSubmitting,
                                type: AppButtonType.primary,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ],

                          // Teacher Assignment
                          if (widget.personnel.isTeacher) ...[
                            Text(
                              'Phân công giảng dạy',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                            ),
                            const SizedBox(height: 12),

                            // Step 1: Class selection
                            BlocBuilder<ClassSelectorBloc, ClassSelectorState>(
                              builder: (context, classState) {
                                if (classState is ClassSelectorLoaded) {
                                  return Focus(
                                    focusNode: _classFocusNode,
                                    child: PrimaryDropdown<String>(
                                      value: _selectedClassId,
                                      hintText: 'Chọn lớp học để phân công',
                                      prefixIcon: Icons.class_outlined,
                                      isFocused: _classFocusNode.hasFocus,
                                      items: classState.classes
                                          .map(
                                            (clazz) => DropdownMenuItem(
                                              value: clazz.id,
                                              child: Text(clazz.name),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: _isSubmitting
                                          ? null
                                          : _onClassSelected,
                                    ),
                                  );
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                            const SizedBox(height: 16),

                            // Loading indicator when fetching assignment
                            if (_isLoadingAssignment) ...[
                              const Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 8),
                                    Text('Đang tải thông tin phân công...'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Step 2: Assignment form (shown after class selection)
                            if (_showAssignmentForm) ...[
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.assignment,
                                          color: _currentAssignment != null
                                              ? Colors.orange
                                              : Colors.green,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _currentAssignment != null
                                                ? 'Cập nhật phân công lớp $_selectedClassName'
                                                : 'Tạo phân công mới cho lớp $_selectedClassName',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _currentAssignment != null
                                                  ? Colors.orange
                                                  : Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    // Subject dropdown
                                    Focus(
                                      focusNode: _subjectFocusNode,
                                      child: PrimaryDropdown<SubjectEnum>(
                                        value: _selectedTeachingSubject,
                                        hintText: 'Chọn môn học',
                                        prefixIcon: Icons.subject_outlined,
                                        isFocused: _subjectFocusNode.hasFocus,
                                        items: widget.personnel.subjects!
                                            .map(
                                              (s) => DropdownMenuItem(
                                                value: s,
                                                child: Text(s.displayName),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: _isSubmitting
                                            ? null
                                            : (val) => setState(
                                                () => _selectedTeachingSubject =
                                                    val,
                                              ),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Vui lòng chọn môn học';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Main teacher checkbox
                                    CheckboxListTile(
                                      title: const Text('Giáo viên chủ nhiệm'),
                                      value: _isMainTeacher,
                                      onChanged: _isSubmitting
                                          ? null
                                          : (val) => setState(
                                              () =>
                                                  _isMainTeacher = val ?? false,
                                            ),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                    ),
                                    const SizedBox(height: 16),

                                    // Action buttons for assignment
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppButton(
                                            onPressed: _isSubmitting
                                                ? null
                                                : _submitAssignmentForm,
                                            text: _currentAssignment != null
                                                ? 'Cập nhật'
                                                : 'Tạo phân công',
                                            loading: _isSubmitting,
                                            type: AppButtonType.primary,
                                          ),
                                        ),
                                        if (_currentAssignment != null) ...[
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: AppButton(
                                              onPressed: _isSubmitting
                                                  ? null
                                                  : _deleteAssignment,
                                              text: 'Xóa phân công',
                                              type: AppButtonType.danger,
                                              loading: _isSubmitting,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],

                          // Submit button for school admin + teacher combination
                          if (widget.personnel.isSchoolAdmin &&
                              widget.personnel.isTeacher) ...[
                            const SizedBox(height: 20),
                            AppButton(
                              onPressed: _isSubmitting
                                  ? null
                                  : _submitSchoolAdminPosition,
                              text: 'Cập nhật chức vụ quản trị',
                              loading:
                                  _isSubmitting && _selectedClassId == null,
                              type: AppButtonType.secondary,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Close button
                  if (!_showSuccessMessage)
                    AppButton(
                      onPressed: _isSubmitting ? null : _closeDialog,
                      text: 'Đóng',
                      type: AppButtonType.cancel,
                    ),

                  // Success message indicator
                  if (_showSuccessMessage) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Đang đóng dialog...',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
