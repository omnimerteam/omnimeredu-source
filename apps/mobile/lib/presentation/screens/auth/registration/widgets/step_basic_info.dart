// lib/presentation/screens/auth/registration/step_basic_info.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/dropdown/register_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/image_picker/app_image_picker.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text_field/register_text_field.dart';

class StepBasicInfo extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  final DateTime? selectedBirthday;
  final ValueChanged<DateTime?> onBirthdayChanged;

  final File? avatarFile;
  final ValueChanged<File?> onPickAvatar;

  final VoidCallback onNext;

  const StepBasicInfo({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.fullNameController,
    required this.phoneController,
    required this.addressController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.selectedBirthday,
    required this.onBirthdayChanged,
    required this.avatarFile,
    required this.onPickAvatar,
    required this.onNext,
  });

  @override
  State<StepBasicInfo> createState() => _StepBasicInfoState();
}

class _StepBasicInfoState extends State<StepBasicInfo> {
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) widget.onPickAvatar(File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ImagePickerWidget(
              imageFile: widget.avatarFile,
              onTap: _pickImage,
              label: 'Chọn ảnh đại diện',
              size: 120,
            ),
          ),
          const SizedBox(height: 24),

          // Email
          RegisterTextField(
            controller: widget.emailController,
            label: 'Email',
            hintText: 'Nhập email của bạn',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng nhập email';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
                return 'Email không hợp lệ';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password
          RegisterTextField(
            controller: widget.passwordController,
            label: 'Mật khẩu',
            hintText: 'Nhập mật khẩu',
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Vui lòng nhập mật khẩu';
              if (value.length < 6) return 'Mật khẩu ít nhất 6 ký tự';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm password
          RegisterTextField(
            controller: widget.confirmPasswordController,
            label: 'Xác nhận mật khẩu',
            hintText: 'Nhập lại mật khẩu',
            isPassword: true,
            validator: (value) {
              if (value != widget.passwordController.text)
                return 'Mật khẩu không khớp';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Full name
          RegisterTextField(
            controller: widget.fullNameController,
            label: 'Họ và tên',
            hintText: 'Nhập họ và tên',
            validator: (value) => (value == null || value.isEmpty)
                ? 'Vui lòng nhập họ tên'
                : null,
          ),
          const SizedBox(height: 16),

          // Gender
          RegisterDropdown<String>(
            label: 'Giới tính',
            value: widget.selectedGender,
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Nam')),
              DropdownMenuItem(value: 'Female', child: Text('Nữ')),
              DropdownMenuItem(value: 'Other', child: Text('Khác')),
            ],
            onChanged: (v) => widget.onGenderChanged(v!),
          ),
          const SizedBox(height: 16),

          // Phone
          RegisterTextField(
            controller: widget.phoneController,
            label: 'Số điện thoại',
            hintText: 'Nhập số điện thoại',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),

          // Birthday (read only)
          RegisterTextField(
            controller: TextEditingController(
              text: widget.selectedBirthday != null
                  ? '${widget.selectedBirthday!.day}/${widget.selectedBirthday!.month}/${widget.selectedBirthday!.year}'
                  : '',
            ),
            label: 'Ngày sinh',
            hintText: 'Chọn ngày sinh',
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(
                  const Duration(days: 365 * 18),
                ),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              widget.onBirthdayChanged(date);
            },
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),

          // Address
          RegisterTextField(
            controller: widget.addressController,
            label: 'Địa chỉ',
            hintText: 'Nhập địa chỉ',
            maxLines: 2,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
