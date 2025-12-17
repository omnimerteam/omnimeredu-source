import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/constants/enum_constant.dart';
import 'package:mobile/domain/entities/grade/grade_entity.dart';
import 'package:mobile/presentation/common/widgets/input/primary_dropdown.dart';
import 'package:mobile/presentation/common/widgets/input/primary_multiline_text_field.dart';
import 'package:mobile/presentation/common/widgets/input/primary_text_field.dart';
import '../bloc/grade_management_bloc.dart';
import '../bloc/grade_management_event.dart';
import '../bloc/grade_management_state.dart';

class GradeFormDialog extends StatefulWidget {
  final GradeEntity? gradeToEdit;

  const GradeFormDialog({super.key, this.gradeToEdit});

  @override
  State<GradeFormDialog> createState() => _GradeFormDialogState();
}

class _GradeFormDialogState extends State<GradeFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _orderController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _minAgeController = TextEditingController();
  final _maxAgeController = TextEditingController();

  final _nameFocus = FocusNode();
  final _orderFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _minAgeFocus = FocusNode();
  final _maxAgeFocus = FocusNode();
  final _levelFocus = FocusNode();
  final _gradeGroupFocus = FocusNode();

  EducationSystemLevelsEnum _selectedLevel = EducationSystemLevelsEnum.Primary;
  EducationGradesEnum? _selectedGradeGroup;

  bool _isActive = true;

  bool get isEditMode => widget.gradeToEdit != null;

  @override
  void initState() {
    super.initState();

    _nameFocus.addListener(_onFocusChange);
    _orderFocus.addListener(_onFocusChange);
    _descriptionFocus.addListener(_onFocusChange);
    _minAgeFocus.addListener(_onFocusChange);
    _maxAgeFocus.addListener(_onFocusChange);
    _levelFocus.addListener(_onFocusChange);
    _gradeGroupFocus.addListener(_onFocusChange);

    _initFormData();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _orderController.dispose();
    _descriptionController.dispose();
    _minAgeController.dispose();
    _maxAgeController.dispose();

    _nameFocus.dispose();
    _orderFocus.dispose();
    _descriptionFocus.dispose();
    _minAgeFocus.dispose();
    _maxAgeFocus.dispose();
    _levelFocus.dispose();
    _gradeGroupFocus.dispose();

    super.dispose();
  }

  void _initFormData() {
    if (isEditMode && widget.gradeToEdit != null) {
      final grade = widget.gradeToEdit!;
      _nameController.text = grade.name;
      _orderController.text = grade.order.toString();
      _descriptionController.text = grade.description ?? '';
      _selectedLevel = grade.level;
      _isActive = grade.active;
      _selectedGradeGroup = grade.gradeGroup;

      if (grade.ageRange != null) {
        _minAgeController.text = grade.ageRange!['min']?.toString() ?? '';
        _maxAgeController.text = grade.ageRange!['max']?.toString() ?? '';
      }
    } else {
      _nameController.clear();
      _orderController.clear();
      _descriptionController.clear();
      _minAgeController.clear();
      _maxAgeController.clear();
      _selectedLevel = EducationSystemLevelsEnum.Primary;
      _isActive = true;
    }
  }

  void _submitForm(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    Map<String, int>? ageRange;
    if (_minAgeController.text.isNotEmpty ||
        _maxAgeController.text.isNotEmpty) {
      ageRange = {};
      if (_minAgeController.text.isNotEmpty) {
        ageRange['min'] = int.parse(_minAgeController.text);
      }
      if (_maxAgeController.text.isNotEmpty) {
        ageRange['max'] = int.parse(_maxAgeController.text);
      }
    }

    final gradeEntity = GradeEntity(
      id: isEditMode ? widget.gradeToEdit?.id : null,
      schoolId: widget.gradeToEdit?.schoolId ?? 'current_school_id',
      name: _nameController.text.trim(),
      level: _selectedLevel,
      gradeGroup: _selectedGradeGroup!,
      order: int.parse(_orderController.text),
      ageRange: ageRange,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      active: _isActive,
      createdAt: widget.gradeToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isEditMode) {
      context.read<GradeManagementBloc>().add(UpdateGradeEvent(gradeEntity));
    } else {
      context.read<GradeManagementBloc>().add(CreateGradeEvent(gradeEntity));
    }
  }

  void _closeDialog(BuildContext context) {
    context.read<GradeManagementBloc>().add(const HideFormEvent());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<GradeManagementBloc, GradeManagementState>(
      listenWhen: (previous, current) {
        if (previous is GradeManagementLoaded &&
            current is GradeManagementLoaded) {
          return previous.formStatus != current.formStatus;
        }
        return false;
      },
      listener: (context, state) {
        if (state is GradeManagementLoaded) {
          if (state.formStatus == GradeManagementFormStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isEditMode
                      ? 'Cập nhật khối thành công!'
                      : 'Tạo khối mới thành công!',
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
            context.read<GradeManagementBloc>().add(const ResetFormEvent());
            Navigator.of(context).pop();
          } else if (state.formStatus == GradeManagementFormStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.formErrorMessage ?? 'Có lỗi xảy ra!'),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        bool isFormLoading = false;

        if (state is GradeManagementFormLoading) {
          isFormLoading = true;
        } else if (state is GradeManagementLoaded) {
          isFormLoading = state.formStatus == GradeManagementFormStatus.loading;
        }

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(maxWidth: 500.w),
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isEditMode ? 'Cập nhật khối' : 'Tạo khối mới',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: isFormLoading
                            ? null
                            : () => _closeDialog(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Name
                  PrimaryTextField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    hintText: 'Tên khối',
                    required: true,
                    prefixIcon: Icons.school_rounded,
                    isFocused: _nameFocus.hasFocus,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Vui lòng nhập tên khối'
                        : null,
                  ),
                  SizedBox(height: 16.h),

                  PrimaryDropdown<String>(
                    value: _selectedLevel.name,
                    required: true,
                    items: EducationSystemLevelsEnum.values
                        .map(
                          (level) => DropdownMenuItem<String>(
                            value: level.name,
                            child: Text(level.displayName),
                          ),
                        )
                        .toList(),
                    hintText: 'Cấp độ',
                    prefixIcon: Icons.layers_rounded,
                    isFocused: _levelFocus.hasFocus,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedLevel = EducationSystemLevelsEnum.values
                              .firstWhere((e) => e.name == val);
                          // Reset grade group when level changes
                          _selectedGradeGroup = null;
                        });
                      }
                    },
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Chọn cấp độ' : null,
                  ),

                  SizedBox(height: 16.h),

                  PrimaryDropdown<EducationGradesEnum>(
                    value: _selectedGradeGroup,
                    required: true,
                    items: _selectedLevel.grades
                        .map(
                          (grade) => DropdownMenuItem<EducationGradesEnum>(
                            value: grade,
                            child: Text(grade.displayName),
                          ),
                        )
                        .toList(),
                    hintText: 'Chọn lớp/Grade *',
                    prefixIcon: Icons.grade_rounded,
                    isFocused: _gradeGroupFocus.hasFocus,
                    onChanged: (val) {
                      setState(() {
                        _selectedGradeGroup = val;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Chọn lớp/Grade' : null,
                  ),

                  SizedBox(height: 16.h),

                  PrimaryTextField(
                    controller: _orderController,
                    focusNode: _orderFocus,
                    hintText: 'Thứ tự',
                    prefixIcon: Icons.format_list_numbered_rounded,
                    isFocused: _orderFocus.hasFocus,
                    keyboardType: TextInputType.number,
                    required: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nhập thứ tự';
                      }
                      final order = int.tryParse(value);
                      if (order == null || order < 1) {
                        return 'Thứ tự phải > 0';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Age range
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryTextField(
                          controller: _minAgeController,
                          focusNode: _minAgeFocus,
                          hintText: 'Tuổi tối thiểu',
                          prefixIcon: Icons.cake_rounded,
                          isFocused: _minAgeFocus.hasFocus,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: PrimaryTextField(
                          controller: _maxAgeController,
                          focusNode: _maxAgeFocus,
                          hintText: 'Tuổi tối đa',
                          prefixIcon: Icons.cake_rounded,
                          isFocused: _maxAgeFocus.hasFocus,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Description
                  PrimaryMultilineTextField(
                    controller: _descriptionController,
                    focusNode: _descriptionFocus,
                    hintText: 'Mô tả',
                    prefixIcon: Icons.description_rounded,
                    maxLines: 3,
                  ),

                  SizedBox(height: 32.h),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isFormLoading
                              ? null
                              : () => _closeDialog(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: const Text('Hủy'),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isFormLoading
                              ? null
                              : () => _submitForm(context),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: isFormLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(isEditMode ? 'Cập nhật' : 'Tạo mới'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
