import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/teaching_assignment/teaching_assignment_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/personnel_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/class/class_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/class/class_state.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/dropdown/primary_dropdown.dart';
import '../bloc/personnel_management_bloc.dart';
import '../bloc/personnel_management_event.dart';
import '../bloc/personnel_management_state.dart';

class AssignmentDialog extends StatefulWidget {
  final PersonnelEntity personnel;
  final TeachingAssignmentEntity? teachingAssignmentEntity;

  const AssignmentDialog({
    super.key,
    required this.personnel,
    this.teachingAssignmentEntity,
  });

  @override
  State<AssignmentDialog> createState() => _AssignmentDialogState();
}

class _AssignmentDialogState extends State<AssignmentDialog> {
  final _formKey = GlobalKey<FormState>();

  // SchoolAdmin
  SchoolAdminPositionEnum? _selectedPosition;

  // Teacher assignment
  String? _selectedClassId;
  SubjectEnum? _selectedTeachingSubject;
  bool _isMainTeacher = false;

  // Existing assignment (for teacher)
  TeachingAssignmentEntity? _existingAssignment;

  // Focus nodes
  final _positionFocusNode = FocusNode();
  final _classFocusNode = FocusNode();
  final _subjectFocusNode = FocusNode();

  // Để track trạng thái submit
  bool _isSubmitting = false;
  bool _showSuccessMessage = false;

  @override
  void initState() {
    super.initState();

    _selectedPosition = widget.personnel.position;

    // Nếu là teacher, load assignment từ bloc/usecase
    if (widget.personnel.isTeacher) {
      final bloc = context.read<PersonnelManagementBloc>();
      final authState = context.read<AuthenticationBloc>().state;
      if (authState is AuthenticationAuthenticated) {
        bloc.add(
          GetTeachingAssignmentByTeacherAndSchoolEvent(
            teacherId: widget.personnel.id!,
            schoolId: authState.user.schoolId!,
          ),
        );
      }
    }

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

  void _submitForm() {
    if (_isSubmitting) return;

    final bloc = context.read<PersonnelManagementBloc>();
    final authState = context.read<AuthenticationBloc>().state;

    if (_formKey.currentState!.validate() &&
        authState is AuthenticationAuthenticated) {
      setState(() {
        _isSubmitting = true;
        _showSuccessMessage = false;
      });

      if (widget.personnel.isSchoolAdmin && _selectedPosition != null) {
        bloc.add(
          UpdateSchoolAdminPositionEvent(
            personnelId: widget.personnel.id!,
            position: _selectedPosition!,
          ),
        );
      }

      if (widget.personnel.isTeacher) {
        // Teacher: create/update assignment
        if (_selectedClassId != null && _selectedTeachingSubject != null) {
          final assignment = TeachingAssignmentEntity(
            teacherId: widget.personnel.id!,
            classId: _selectedClassId!,
            schoolId: authState.user.schoolId!,
            subject: _selectedTeachingSubject!,
            isMain: _isMainTeacher,
            id: _existingAssignment?.id,
          );

          if (_existingAssignment != null) {
            bloc.add(UpdateTeachingAssignmentEvent(assignment));
          } else {
            bloc.add(CreateTeachingAssignmentEvent(assignment));
          }
        }
      }
    }
  }

  // void _deleteAssignment() {
  //   if (_existingAssignment != null && !_isSubmitting) {
  //     setState(() {
  //       _isSubmitting = true;
  //       _showSuccessMessage = false;
  //     });

  //     context.read<PersonnelManagementBloc>().add(
  //       DeleteTeachingAssignmentEvent(_existingAssignment!.id!),
  //     );
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PersonnelManagementBloc, PersonnelManagementState>(
      listener: (context, state) {
        if (state is PersonnelManagementLoaded) {
          if (state.assignmentStatus == PersonnelAssignmentStatus.success) {
            if (state.currentTeachingAssignment != null &&
                _existingAssignment == null &&
                !_isSubmitting) {
              // Đây là lúc load GET assignment
              setState(() {
                _existingAssignment = state.currentTeachingAssignment;
                _selectedClassId = _existingAssignment!.classId;
                _selectedTeachingSubject = _existingAssignment!.subject;
                _isMainTeacher = _existingAssignment!.isMain;
              });
            } else if (_isSubmitting) {
              // Đây là lúc CREATE/UPDATE/DELETE thành công
              String message = 'Cập nhật thành công';
              if (widget.personnel.isSchoolAdmin) {
                message = 'Cập nhật chức vụ thành công';
              } else if (widget.personnel.isTeacher) {
                if (_existingAssignment != null) {
                  message = 'Cập nhật phân công thành công';
                } else {
                  message = 'Tạo phân công thành công';
                }
              }
              _handleSuccess(message);
            }
          } else if (state.assignmentStatus ==
              PersonnelAssignmentStatus.error) {
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
                  SizedBox(height: 16),
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

                            // Class dropdown
                            BlocBuilder<ClassBloc, ClassState>(
                              builder: (context, classState) {
                                if (classState is ClassLoaded) {
                                  return Focus(
                                    focusNode: _classFocusNode,
                                    child: PrimaryDropdown<String>(
                                      value: _selectedClassId,
                                      hintText: 'Chọn lớp học',
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
                                          : (val) => setState(
                                              () => _selectedClassId = val,
                                            ),
                                    ),
                                  );
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                            const SizedBox(height: 16),

                            // Subject dropdown
                            Focus(
                              focusNode: _subjectFocusNode,
                              child: PrimaryDropdown<SubjectEnum>(
                                value: _selectedTeachingSubject,
                                hintText: 'Môn học',
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
                                        () => _selectedTeachingSubject = val,
                                      ),
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
                                      () => _isMainTeacher = val ?? false,
                                    ),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            const SizedBox(height: 20),

                            // Delete assignment button
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  if (!_showSuccessMessage)
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            onPressed: _isSubmitting ? null : _closeDialog,
                            text: 'Hủy',
                            type: AppButtonType.cancel,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AppButton(
                            onPressed: _isSubmitting ? null : _submitForm,
                            text: 'Cập nhật',
                            loading: _isSubmitting,
                            type: AppButtonType.primary,
                          ),
                        ),
                        // const SizedBox(width: 16),
                        // if (_existingAssignment != null)
                        //   Expanded(
                        //     child: AppButton(
                        //       onPressed: _isSubmitting
                        //           ? null
                        //           : _deleteAssignment,
                        //       text: 'Xóa phân công',
                        //       type: AppButtonType.danger,
                        //       loading: _isSubmitting,
                        //     ),
                        //   ),
                      ],
                    ),

                  // Loading indicator when showing success
                  if (_showSuccessMessage) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
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
