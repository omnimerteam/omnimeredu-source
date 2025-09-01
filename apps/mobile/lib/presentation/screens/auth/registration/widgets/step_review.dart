// lib/presentation/screens/auth/registration/step_review.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/core/utils/display_mapper.dart';
import 'package:flutter_ios_android_platforms/domain/entities/role.dart';

class StepReview extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController fullNameController;
  final String selectedGender;
  final TextEditingController phoneController;
  final DateTime? selectedBirthday;
  final TextEditingController addressController;
  final File? avatarFile;

  final RoleEntity? selectedRole;
  final String? selectedEducationLevel;
  final TextEditingController schoolCodeController;
  final TextEditingController gradeController;
  final TextEditingController guardianNameController;
  final TextEditingController guardianPhoneController;
  final TextEditingController literacyController;
  final TextEditingController subjectsController;

  final bool isCreateNewSchool;
  final TextEditingController positionController;
  final TextEditingController schoolNameController;
  final TextEditingController schoolAddressController;
  final TextEditingController schoolPhoneController;
  final TextEditingController schoolDescriptionController;
  final File? schoolLogoFile;

  final VoidCallback onPrevious;
  final VoidCallback onSubmit;

  const StepReview({
    super.key,
    required this.emailController,
    required this.fullNameController,
    required this.selectedGender,
    required this.phoneController,
    required this.selectedBirthday,
    required this.addressController,
    required this.avatarFile,
    required this.selectedRole,
    required this.selectedEducationLevel,
    required this.schoolCodeController,
    required this.gradeController,
    required this.guardianNameController,
    required this.guardianPhoneController,
    required this.literacyController,
    required this.subjectsController,
    required this.isCreateNewSchool,
    required this.positionController,
    required this.schoolNameController,
    required this.schoolAddressController,
    required this.schoolPhoneController,
    required this.schoolDescriptionController,
    required this.schoolLogoFile,
    required this.onPrevious,
    required this.onSubmit,
  });

  String _genderDisplay(String g) {
    switch (g) {
      case 'Male':
        return 'Nam';
      case 'Female':
        return 'Nữ';
      case 'Other':
        return 'Khác';
      default:
        return g;
    }
  }

  String? _educationDisplay(String? level) {
    if (level == null) return null;
    switch (level) {
      case 'Preschool':
        return 'Mầm non';
      case 'Primary':
        return 'Tiểu học';
      case 'Secondary':
        return 'Trung học cơ sở';
      case 'HighSchool':
        return 'Trung học phổ thông';
      default:
        return level;
    }
  }

  Widget _reviewItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xem lại thông tin',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Basic info card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông tin cơ bản',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                _reviewItem('Email', emailController.text),
                _reviewItem('Họ và tên', fullNameController.text),
                _reviewItem('Giới tính', _genderDisplay(selectedGender)),
                if (phoneController.text.isNotEmpty)
                  _reviewItem('SĐT', phoneController.text),
                if (selectedBirthday != null)
                  _reviewItem(
                    'Ngày sinh',
                    '${selectedBirthday!.day}/${selectedBirthday!.month}/${selectedBirthday!.year}',
                  ),
                if (addressController.text.isNotEmpty)
                  _reviewItem('Địa chỉ', addressController.text),
                if (avatarFile != null) _reviewItem('Ảnh đại diện', 'Đã chọn'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (selectedRole != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin công việc',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _reviewItem(
                    'Công việc',
                    DisplayMapper.roleName(selectedRole!.name),
                  ),
                  if (selectedRole!.name.toLowerCase() == 'student') ...[
                    _reviewItem(
                      'Cấp học',
                      _educationDisplay(selectedEducationLevel),
                    ),
                    _reviewItem('Mã trường', schoolCodeController.text),
                    if (gradeController.text.isNotEmpty)
                      _reviewItem('Lớp', gradeController.text),
                    _reviewItem('Tên phụ huynh', guardianNameController.text),
                    _reviewItem('SĐT phụ huynh', guardianPhoneController.text),
                  ],
                  if (selectedRole!.name.toLowerCase() == 'teacher') ...[
                    _reviewItem('Mã trường', schoolCodeController.text),
                    _reviewItem('Trình độ', literacyController.text),
                    _reviewItem('Môn giảng dạy', subjectsController.text),
                  ],
                  if (selectedRole!.name.toLowerCase() == 'schooladmin') ...[
                    if (!isCreateNewSchool) ...[
                      _reviewItem('Mã trường', schoolCodeController.text),
                      _reviewItem('Chức vụ', positionController.text),
                    ] else ...[
                      _reviewItem('Tên trường', schoolNameController.text),
                      _reviewItem('Mã trường', schoolCodeController.text),
                      _reviewItem(
                        'Cấp trường',
                        _educationDisplay(selectedEducationLevel),
                      ),
                      _reviewItem(
                        'Địa chỉ trường',
                        schoolAddressController.text,
                      ),
                      if (schoolPhoneController.text.isNotEmpty)
                        _reviewItem('SĐT trường', schoolPhoneController.text),
                      if (schoolDescriptionController.text.isNotEmpty)
                        _reviewItem(
                          'Mô tả trường',
                          schoolDescriptionController.text,
                        ),
                      if (schoolLogoFile != null)
                        _reviewItem('Logo trường', 'Đã chọn'),
                    ],
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
