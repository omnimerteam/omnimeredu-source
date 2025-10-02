import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/display_mapper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/class_selector.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/validator.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/dropdown/primary_dropdown.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text_field/primary_text_field.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/student/student_managent/bloc/student_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/student/student_managent/bloc/student_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/student/student_managent/bloc/student_management_state.dart';

class StudentFormDialog extends StatefulWidget {
  final StudentEntity? studentToEdit;

  const StudentFormDialog({super.key, this.studentToEdit});

  @override
  State<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<StudentFormDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _birthdayController;
  late TextEditingController _guardianNameController;
  late TextEditingController _guardianPhoneController;

  // Focus Nodes
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _birthdayFocusNode = FocusNode();
  final _genderFocusNode = FocusNode();
  final _gradeFocusNode = FocusNode();
  final _classFocusNode = FocusNode();
  final _guardianNameFocusNode = FocusNode();
  final _guardianPhoneFocusNode = FocusNode();

  // Form data
  String? _selectedGender;
  EducationGradesEnum? _selectedGrade;
  String? _selectedClassId;
  DateTime? _selectedBirthday;
  EducationSystemLevelsEnum? _selectedEducationLevel;

  // Track submit state
  bool _isSubmitting = false;
  bool _showSuccessMessage = false;

  bool get isEditMode => widget.studentToEdit != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _birthdayController = TextEditingController();
    _guardianNameController = TextEditingController();
    _guardianPhoneController = TextEditingController();

    // focus listeners
    _nameFocusNode.addListener(() => setState(() {}));
    _emailFocusNode.addListener(() => setState(() {}));
    _phoneFocusNode.addListener(() => setState(() {}));
    _addressFocusNode.addListener(() => setState(() {}));
    _birthdayFocusNode.addListener(() => setState(() {}));
    _genderFocusNode.addListener(() => setState(() {}));
    _gradeFocusNode.addListener(() => setState(() {}));
    _classFocusNode.addListener(() => setState(() {}));
    _guardianNameFocusNode.addListener(() => setState(() {}));
    _guardianPhoneFocusNode.addListener(() => setState(() {}));

    _initFormData();
  }

  void _initFormData() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();
    _birthdayController.clear();
    _guardianNameController.clear();
    _guardianPhoneController.clear();

    _selectedGender = null;
    _selectedGrade = null;
    _selectedClassId = null;
    _selectedBirthday = null;

    final authState = context.read<AuthenticationBloc>().state;
    _selectedEducationLevel =
        (authState is AuthenticationAuthenticated
            ? authState.user.schoolLevel
            : null) ??
        EducationSystemLevelsEnum.None;
    _selectedGrade = null;
    _selectedClassId = null;

    if (isEditMode && widget.studentToEdit != null) {
      final student = widget.studentToEdit!;
      _nameController.text = student.fullName;
      _emailController.text = student.email ?? '';
      _phoneController.text = student.phone ?? '';
      _addressController.text = student.address ?? '';
      _selectedGender = student.gender;
      _guardianNameController.text = student.guardianName ?? '';
      _guardianPhoneController.text = student.guardianPhone ?? '';
      _selectedEducationLevel = student.educationLevel;
      _selectedGrade =
          widget.studentToEdit?.gradeGroup ??
          _selectedEducationLevel!.grades.first;

      // birthday
      if (student.birthday != null) {
        _selectedBirthday = student.birthday;
        _birthdayController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(student.birthday!);
      }

      if (student.classId != null) {
        _selectedClassId = student.classId!;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthdayController.dispose();
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _addressFocusNode.dispose();
    _birthdayFocusNode.dispose();
    _genderFocusNode.dispose();
    _gradeFocusNode.dispose();
    _classFocusNode.dispose();
    _guardianNameFocusNode.dispose();
    _guardianPhoneFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_isSubmitting) return;

    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthenticationBloc>().state;
      if (authState is! AuthenticationAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể xác định thông tin trường học'),
          ),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
        _showSuccessMessage = false;
      });

      final studentEntity = StudentEntity(
        id: isEditMode ? widget.studentToEdit!.id : null,
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        educationLevel: _selectedEducationLevel!,
        birthday: _selectedBirthday,
        gender: _selectedGender,
        gradeGroup: _selectedGrade,
        schoolId: authState.user.schoolId,
        classId: _selectedClassId,
        guardianName: _guardianNameController.text.trim().isEmpty
            ? null
            : _guardianNameController.text.trim(),
        guardianPhone: _guardianPhoneController.text.trim().isEmpty
            ? null
            : _guardianPhoneController.text.trim(),
      );

      if (isEditMode) {
        context.read<StudentManagementBloc>().add(
          UpdateStudentEvent(studentEntity),
        );
      } else {
        context.read<StudentManagementBloc>().add(
          CreateStudentEvent(studentEntity),
        );
      }
    }
  }

  void _closeDialog() {
    if (_isSubmitting) return;

    context.read<StudentManagementBloc>().add(HideFormEvent());
    Navigator.of(context).pop();
  }

  void _handleSuccess(String message) {
    setState(() {
      _isSubmitting = false;
      _showSuccessMessage = true;
    });

    // Wait 1.5 seconds to show success message then close dialog
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        context.read<StudentManagementBloc>().add(HideFormEvent());
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

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedBirthday ??
          DateTime.now().subtract(const Duration(days: 365 * 6)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
        _birthdayController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentManagementBloc, StudentManagementState>(
      listener: (context, state) {
        if (state is StudentManagementLoaded) {
          if (state.formStatus == StudentManagementFormStatus.success) {
            _handleSuccess(
              (isEditMode
                  ? 'Cập nhật học sinh thành công!'
                  : 'Tạo học sinh thành công!'),
            );
          } else if (state.formStatus == StudentManagementFormStatus.error) {
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
                  // Header with close button
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isEditMode
                              ? 'Cập nhật học sinh'
                              : 'Thêm học sinh mới',
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
                          // === PERSONAL INFO ===
                          Text(
                            "Thông tin cá nhân",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                          ),
                          const SizedBox(height: 12),

                          // Full name
                          PrimaryTextField(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            hintText: 'Họ và tên học sinh',
                            prefixIcon: Icons.person_outline,
                            isFocused: _nameFocusNode.hasFocus,
                            validator: (value) => Validators.requiredField(
                              value,
                              name: 'Họ và tên',
                            ),
                            required: true,
                          ),
                          const SizedBox(height: 16),

                          // Email
                          PrimaryTextField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            hintText: 'Email học sinh',
                            prefixIcon: Icons.email_outlined,
                            isFocused: _emailFocusNode.hasFocus,
                            validator: (value) {
                              if (value?.trim().isNotEmpty == true) {
                                return Validators.email(value);
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Birthday
                          PrimaryTextField(
                            controller: _birthdayController,
                            focusNode: _birthdayFocusNode,
                            hintText: 'Ngày sinh',
                            prefixIcon: Icons.cake_outlined,
                            isFocused: _birthdayFocusNode.hasFocus,
                            readOnly: true,
                            onTap: () => _selectBirthday(context),
                            suffixIcon: _birthdayController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _selectedBirthday = null;
                                        _birthdayController.clear();
                                      });
                                    },
                                  )
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // Gender
                          Focus(
                            focusNode: _genderFocusNode,
                            child: PrimaryDropdown<String>(
                              value: _selectedGender,
                              hintText: 'Giới tính',
                              prefixIcon: Icons.person_outline,
                              isFocused: _genderFocusNode.hasFocus,
                              items: DisplayMapper.gender.entries.map((entry) {
                                return DropdownMenuItem<String>(
                                  value: entry.key,
                                  child: Text(entry.value),
                                );
                              }).toList(),
                              onChanged: _isSubmitting
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _selectedGender = value;
                                      });
                                    },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Phone
                          PrimaryTextField(
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            hintText: 'Số điện thoại',
                            prefixIcon: Icons.phone_outlined,
                            isFocused: _phoneFocusNode.hasFocus,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value?.trim().isNotEmpty == true) {
                                return Validators.phone(value);
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Address
                          PrimaryTextField(
                            controller: _addressController,
                            focusNode: _addressFocusNode,
                            hintText: 'Địa chỉ (không bắt buộc)',
                            prefixIcon: Icons.location_on_outlined,
                            isFocused: _addressFocusNode.hasFocus,
                          ),

                          const SizedBox(height: 24),

                          // === FAMILY INFO ===
                          Text(
                            "Thông tin gia đình",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                          ),
                          const SizedBox(height: 12),

                          // Guardian name
                          PrimaryTextField(
                            controller: _guardianNameController,
                            focusNode: _guardianNameFocusNode,
                            hintText: 'Tên phụ huynh',
                            prefixIcon: Icons.person,
                            isFocused: _guardianNameFocusNode.hasFocus,
                            validator: (value) => Validators.requiredField(
                              value,
                              name: 'Tên phụ huynh',
                            ),
                            required: true,
                          ),
                          const SizedBox(height: 16),

                          // Guardian phone
                          PrimaryTextField(
                            controller: _guardianPhoneController,
                            focusNode: _guardianPhoneFocusNode,
                            hintText: 'Số điện thoại phụ huynh',
                            prefixIcon: Icons.phone,
                            isFocused: _guardianPhoneFocusNode.hasFocus,
                            keyboardType: TextInputType.phone,
                            validator: (value) => Validators.requiredField(
                              value,
                              name: 'Số điện thoại phụ huynh',
                            ),
                            required: true,
                          ),

                          const SizedBox(height: 24),

                          // === EDUCATION INFO ===
                          Text(
                            "Thông tin học tập",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                          ),
                          const SizedBox(height: 12),

                          // Education Level
                          PrimaryDropdown<EducationSystemLevelsEnum>(
                            required: true,
                            value: _selectedEducationLevel,
                            hintText: 'Chọn cấp học',
                            prefixIcon: Icons.school,
                            isFocused: _gradeFocusNode.hasFocus,
                            items: EducationSystemLevelsEnum.values.map((
                              level,
                            ) {
                              return DropdownMenuItem(
                                value: level,
                                child: Text(level.displayName),
                              );
                            }).toList(),
                            onChanged: _isSubmitting
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedEducationLevel = value;
                                    });
                                  },
                            validator: (value) => Validators.requiredField(
                              value?.name,
                              name: 'Cấp học',
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Grade
                          PrimaryDropdown<EducationGradesEnum>(
                            required: true,
                            value: _selectedGrade,
                            hintText: 'Chọn khối lớp *',
                            prefixIcon: Icons.school_outlined,
                            isFocused: _gradeFocusNode.hasFocus,
                            items: _selectedEducationLevel!.grades.map((
                              gradeGroup,
                            ) {
                              return DropdownMenuItem(
                                value: gradeGroup,
                                child: Text(gradeGroup.displayName),
                              );
                            }).toList(),
                            onChanged: _isSubmitting
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedGrade = value;
                                    });
                                  },
                            validator: (value) => Validators.requiredField(
                              value?.name,
                              name: 'Khối lớp',
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Class selector
                          BlocBuilder<AuthenticationBloc, AuthenticationState>(
                            builder: (context, authState) {
                              if (authState is AuthenticationAuthenticated &&
                                  authState.user.schoolId != null) {
                                return BlocProvider.value(
                                  value: context.read<ClassSelectorBloc>(),
                                  child: ClassSelector(
                                    schoolId: authState.user.schoolId!,
                                    gradeGroup: _selectedGrade,
                                    initialClassId: _selectedClassId,
                                    autoLoad: false,
                                    onClassSelected: (classEntity) {
                                      setState(() {
                                        _selectedClassId = classEntity?.id;
                                      });
                                    },
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Error message
                  if (state is StudentManagementLoaded &&
                      state.formStatus == StudentManagementFormStatus.error &&
                      state.formErrorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        state.formErrorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

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
                            text: isEditMode ? 'Cập nhật' : 'Tạo mới',
                            loading: _isSubmitting,
                            type: AppButtonType.primary,
                          ),
                        ),
                      ],
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
