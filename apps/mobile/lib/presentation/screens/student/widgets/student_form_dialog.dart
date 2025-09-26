import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/class/class_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/display_mapper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/widgets/class_selector.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/validator.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/dropdown/primary_dropdown.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text_field/primary_text_field.dart';
import '../bloc/student_management_bloc.dart';
import '../bloc/student_management_event.dart';
import '../bloc/student_management_state.dart';

// ... import giữ nguyên
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

      // gradeGroup
      if (student.gradeGroup != null) {
        try {
          _selectedGrade = EducationGradesEnum.fromString(
            student.gradeGroup!.displayName,
          );
        } catch (_) {}
      }

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
    _phoneController.dispose();
    _addressController.dispose();
    _birthdayController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _addressFocusNode.dispose();
    _birthdayFocusNode.dispose();
    _genderFocusNode.dispose();
    _gradeFocusNode.dispose();
    _classFocusNode.dispose();
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    _guardianNameFocusNode.dispose();
    _guardianPhoneFocusNode.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
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
        educationLevel: authState.user.educationLevel!,
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

  void _closeDialog(BuildContext context) {
    context.read<StudentManagementBloc>().add(HideFormEvent());
    Navigator.of(context).pop();
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
      // listenWhen: (previous, current) {
      //   if (previous is StudentManagementLoaded &&
      //       current is StudentManagementLoaded) {
      //     return previous.formStatus != current.formStatus;
      //   }
      //   return false;
      // },
      listenWhen: (previous, current) {
        // Lắng nghe khi trạng thái form thay đổi
        if (current is StudentManagementLoaded) {
          return current.formStatus != StudentManagementFormStatus.initial;
        }
        return false;
      },
      listener: (context, state) {
        if (state is StudentManagementLoaded &&
            state.formStatus == StudentManagementFormStatus.success) {
          // Hiển thị thông báo thành công
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditMode
                    ? 'Cập nhật học sinh thành công!'
                    : 'Tạo học sinh thành công!',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Đóng form sau khi thành công
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        final isFormLoading =
            state is StudentManagementFormLoading ||
            (state is StudentManagementLoaded &&
                state.formStatus == StudentManagementFormStatus.loading);

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                        onPressed: () => _closeDialog(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- THÔNG TIN CÁ NHÂN ---
                        Text(
                          "Thông tin cá nhân",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                        ),
                        const SizedBox(height: 12),

                        // Họ tên
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

                        PrimaryTextField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          hintText: 'Email học sinh',
                          prefixIcon: Icons.person_outline,
                          isFocused: _emailFocusNode.hasFocus,
                          validator: (value) {
                            if (value?.trim().isNotEmpty == true) {
                              return Validators.email(value);
                            }
                            return null;
                          },
                          required: true,
                        ),
                        const SizedBox(height: 16),

                        // Ngày sinh
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

                        // Giới tính
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
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Số điện thoại
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

                        // Địa chỉ
                        PrimaryTextField(
                          controller: _addressController,
                          focusNode: _addressFocusNode,
                          hintText: 'Địa chỉ (không bắt buộc)',
                          prefixIcon: Icons.location_on_outlined,
                          isFocused: _addressFocusNode.hasFocus,
                        ),

                        const SizedBox(height: 24),

                        // --- THÔNG TIN GIA ĐÌNH ---
                        Text(
                          "Thông tin gia đình",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                        ),
                        const SizedBox(height: 12),

                        // Tên phụ huynh
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

                        // SĐT phụ huynh
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

                        // --- THÔNG TIN HỌC TẬP ---
                        Text(
                          "Thông tin học tập",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                        ),
                        const SizedBox(height: 12),

                        // Cấp học
                        BlocBuilder<AuthenticationBloc, AuthenticationState>(
                          builder: (context, authState) {
                            if (authState is AuthenticationAuthenticated) {
                              _selectedEducationLevel ??=
                                  authState.user.educationLevel;
                              return PrimaryDropdown<EducationSystemLevelsEnum>(
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
                                onChanged: (value) {
                                  setState(() {
                                    _selectedEducationLevel = value;
                                  });
                                },
                                validator: (value) => Validators.requiredField(
                                  value?.name,
                                  name: 'Cấp học',
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 16),

                        // Khối lớp
                        BlocBuilder<AuthenticationBloc, AuthenticationState>(
                          builder: (context, authState) {
                            if (authState is AuthenticationAuthenticated &&
                                authState.user.schoolLevel != null) {
                              return PrimaryDropdown<EducationGradesEnum>(
                                required: true,
                                value: _selectedGrade,
                                hintText: 'Chọn khối lớp *',
                                prefixIcon: Icons.school_outlined,
                                isFocused: _gradeFocusNode.hasFocus,
                                items: authState.user.schoolLevel!.grades.map((
                                  gradeGroup,
                                ) {
                                  return DropdownMenuItem(
                                    value: gradeGroup,
                                    child: Text(gradeGroup.displayName),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGrade = value;
                                  });
                                },
                                validator: (value) => Validators.requiredField(
                                  value?.name,
                                  name: 'Khối lớp',
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 16),

                        // Lớp học
                        BlocBuilder<AuthenticationBloc, AuthenticationState>(
                          builder: (context, authState) {
                            if (authState is AuthenticationAuthenticated &&
                                authState.user.schoolId != null) {
                              return BlocProvider.value(
                                value: context.read<ClassBloc>(),
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

                  const SizedBox(height: 10),
                  // Error message
                  if (state is StudentManagementLoaded &&
                      state.formStatus == StudentManagementFormStatus.error &&
                      state.formErrorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        state.formErrorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 10),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          onPressed: isFormLoading
                              ? null
                              : () => _closeDialog(context),
                          text: 'Hủy',
                          type: AppButtonType.danger,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          onPressed: isFormLoading
                              ? null
                              : () => _submitForm(context),
                          text: isEditMode ? 'Cập nhật' : 'Tạo mới',
                          loading: isFormLoading,
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
