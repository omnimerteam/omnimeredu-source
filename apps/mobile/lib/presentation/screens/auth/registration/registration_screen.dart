// lib/presentation/screens/auth/registration/registration_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/base_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/register_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/role.dart';
import 'package:flutter_ios_android_platforms/domain/entities/school_data.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/widgets/already_have_account.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/widgets/step_basic_info.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/widgets/step_review.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/widgets/step_role.dart';

import 'package:flutter_ios_android_platforms/presentation/widgets/button/register_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // --- controllers kept centrally here ---
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController schoolCodeController = TextEditingController();
  final TextEditingController guardianNameController = TextEditingController();
  final TextEditingController guardianPhoneController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  final TextEditingController literacyController = TextEditingController();
  final TextEditingController subjectsController = TextEditingController();

  final TextEditingController positionController = TextEditingController(
    text: "Hiệu trưởng",
  );
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController schoolAddressController = TextEditingController();
  final TextEditingController schoolPhoneController = TextEditingController();
  final TextEditingController schoolDescriptionController =
      TextEditingController();
  final TextEditingController schoolEmailController = TextEditingController();

  // state fields
  String selectedGender = 'Male';
  DateTime? selectedBirthday;
  RoleEntity? selectedRole;
  String? selectedEducationLevel;
  String? selectedSchoolLevel;
  File? avatarImage;
  File? schoolLogoImage;
  bool isCreateNewSchool = false;

  int currentPage = 0;
  final int totalPages = 3;

  @override
  void initState() {
    super.initState();
    context.read<RegistrationBloc>().add(LoadRolesEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    schoolCodeController.dispose();
    guardianNameController.dispose();
    guardianPhoneController.dispose();
    gradeController.dispose();
    literacyController.dispose();
    subjectsController.dispose();
    positionController.dispose();
    schoolNameController.dispose();
    schoolAddressController.dispose();
    schoolPhoneController.dispose();
    schoolDescriptionController.dispose();
    schoolEmailController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentPage < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitRegistration() {
    if (!_formKey.currentState!.validate()) return;

    Map<String, dynamic>? specificInfo;
    SchoolDataEntity? schoolData;

    final roleName = selectedRole?.name.toLowerCase();

    if (roleName == 'student') {
      specificInfo = {
        'guardianName': guardianNameController.text.trim(),
        'guardianPhone': guardianPhoneController.text.trim(),
        'educationLevel': selectedEducationLevel,
        'grade': gradeController.text.trim(),
      };
    } else if (roleName == 'teacher') {
      specificInfo = {
        'literacy': literacyController.text.trim(),
        'subjects': subjectsController.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
      };
    } else if (roleName == 'schooladmin') {
      if (isCreateNewSchool) {
        schoolData = SchoolDataEntity(
          id: '',
          name: schoolNameController.text.trim(),
          code: schoolCodeController.text.trim(),
          address: schoolAddressController.text.trim(),
          phone: schoolPhoneController.text.trim().isEmpty
              ? null
              : schoolPhoneController.text.trim(),
          description: schoolDescriptionController.text.trim().isEmpty
              ? null
              : schoolDescriptionController.text.trim(),
          level: selectedSchoolLevel ?? '',
        );
      } else {
        specificInfo = {'position': positionController.text.trim()};
      }
    }

    final registerEntity = RegisterUserEntity(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      baseUserInfo: BaseUserEntity(
        roleId: selectedRole!.id,
        fullName: fullNameController.text.trim(),
        gender: selectedGender,
        phone: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        birthday: selectedBirthday,
        address: addressController.text.trim().isEmpty
            ? null
            : addressController.text.trim(),
      ),
      schoolId: isCreateNewSchool ? null : schoolCodeController.text.trim(),
      specificInfo: specificInfo,
      schoolData: schoolData,
    );

    context.read<RegistrationBloc>().add(
      RegisterUserEvent(
        registerEntity,
        avatarFile: avatarImage,
        schoolLogoFile: schoolLogoImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        title: const Text(
          'Đăng ký tài khoản',
          style: TextStyle(
            fontFamily: 'Inter', // tên font đã khai báo
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đăng ký thành công!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is RegistrationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            // progress bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: List.generate(totalPages, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index < totalPages - 1 ? 8 : 0,
                      ),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= currentPage
                            ? AppColors.primary
                            : AppColors.extraLightBlue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // pages
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (p) => setState(() => currentPage = p),
                  children: [
                    StepBasicInfo(
                      // pass controllers & state
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      fullNameController: fullNameController,
                      phoneController: phoneController,
                      addressController: addressController,
                      selectedGender: selectedGender,
                      onGenderChanged: (g) =>
                          setState(() => selectedGender = g),
                      selectedBirthday: selectedBirthday,
                      onBirthdayChanged: (d) =>
                          setState(() => selectedBirthday = d),
                      avatarFile: avatarImage,
                      onPickAvatar: (file) =>
                          setState(() => avatarImage = file),
                      onNext: _nextPage,
                    ),
                    StepRole(
                      // pass controllers & state
                      selectedRole: selectedRole,
                      onRoleChanged: (r) => setState(() => selectedRole = r),
                      selectedEducationLevel: selectedEducationLevel,
                      onEducationLevelChanged: (v) =>
                          setState(() => selectedEducationLevel = v),
                      schoolCodeController: schoolCodeController,
                      guardianNameController: guardianNameController,
                      guardianPhoneController: guardianPhoneController,
                      gradeController: gradeController,
                      literacyController: literacyController,
                      subjectsController: subjectsController,
                      isCreateNewSchool: isCreateNewSchool,
                      onToggleCreateSchool: (v) =>
                          setState(() => isCreateNewSchool = v),
                      positionController: positionController,
                      schoolNameController: schoolNameController,
                      schoolAddressController: schoolAddressController,
                      schoolPhoneController: schoolPhoneController,
                      schoolDescriptionController: schoolDescriptionController,
                      schoolEmailController: schoolEmailController,
                      selectedSchoolLevel: selectedSchoolLevel,
                      onSchoolLevelChanged: (v) =>
                          setState(() => selectedSchoolLevel = v),
                      onPickSchoolLogo: (file) =>
                          setState(() => schoolLogoImage = file),
                      onNext: _nextPage,
                      onPrevious: _previousPage,
                    ),
                    StepReview(
                      // pass everything for review
                      emailController: emailController,
                      fullNameController: fullNameController,
                      selectedGender: selectedGender,
                      phoneController: phoneController,
                      selectedBirthday: selectedBirthday,
                      addressController: addressController,
                      avatarFile: avatarImage,
                      selectedRole: selectedRole,
                      selectedEducationLevel: selectedEducationLevel,
                      schoolCodeController: schoolCodeController,
                      gradeController: gradeController,
                      guardianNameController: guardianNameController,
                      guardianPhoneController: guardianPhoneController,
                      literacyController: literacyController,
                      subjectsController: subjectsController,
                      isCreateNewSchool: isCreateNewSchool,
                      positionController: positionController,
                      schoolNameController: schoolNameController,
                      schoolAddressController: schoolAddressController,
                      schoolPhoneController: schoolPhoneController,
                      schoolDescriptionController: schoolDescriptionController,
                      schoolLogoFile: schoolLogoImage,
                      onPrevious: _previousPage,
                      onSubmit: _submitRegistration,
                    ),
                  ],
                ),
              ),
            ),

            // navigation buttons (bottom)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (currentPage > 0)
                    Expanded(
                      child: RegisterButton(
                        text: 'Quay lại',
                        onPressed: _previousPage,
                        isOutlined: true,
                      ),
                    ),
                  if (currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    child: BlocBuilder<RegistrationBloc, RegistrationState>(
                      builder: (context, state) {
                        final isLast = currentPage == totalPages - 1;
                        return RegisterButton(
                          text: isLast ? 'Đăng ký' : 'Tiếp tục',
                          onPressed: isLast ? _submitRegistration : _nextPage,
                          isLoading: state is RegistrationLoading,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AlreadyHaveAccount(
              onLoginTap: () {
                // Điều hướng sang màn đăng nhập
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
