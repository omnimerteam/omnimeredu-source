// lib/presentation/screens/auth/registration/step_role.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/utils/display_mapper.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_state.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/dropdown/register_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/image_picker/app_image_picker.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text_field/register_text_field.dart';
import 'package:flutter_ios_android_platforms/domain/entities/role.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_bloc.dart';

class StepRole extends StatefulWidget {
  final RoleEntity? selectedRole;
  final ValueChanged<RoleEntity?> onRoleChanged;

  final String? selectedEducationLevel;
  final ValueChanged<String?> onEducationLevelChanged;

  final TextEditingController schoolCodeController;
  final TextEditingController guardianNameController;
  final TextEditingController guardianPhoneController;
  final TextEditingController gradeController;

  final TextEditingController literacyController;
  final TextEditingController subjectsController;

  final bool isCreateNewSchool;
  final ValueChanged<bool> onToggleCreateSchool;

  final TextEditingController positionController;
  final TextEditingController schoolNameController;
  final TextEditingController schoolAddressController;
  final TextEditingController schoolPhoneController;
  final TextEditingController schoolDescriptionController;
  final TextEditingController schoolEmailController;

  final String? selectedSchoolLevel;
  final ValueChanged<String?> onSchoolLevelChanged;

  final ValueChanged<File?> onPickSchoolLogo;

  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const StepRole({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.selectedEducationLevel,
    required this.onEducationLevelChanged,
    required this.schoolCodeController,
    required this.guardianNameController,
    required this.guardianPhoneController,
    required this.gradeController,
    required this.literacyController,
    required this.subjectsController,
    required this.isCreateNewSchool,
    required this.onToggleCreateSchool,
    required this.positionController,
    required this.schoolNameController,
    required this.schoolAddressController,
    required this.schoolPhoneController,
    required this.schoolDescriptionController,
    required this.schoolEmailController,
    required this.selectedSchoolLevel,
    required this.onSchoolLevelChanged,
    required this.onPickSchoolLogo,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<StepRole> createState() => _StepRoleState();
}

class _StepRoleState extends State<StepRole> {
  File? _localSchoolLogo;

  Future<void> _pickSchoolLogo() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      setState(() => _localSchoolLogo = file);
      widget.onPickSchoolLogo(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin vai trò',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // roles from bloc
          BlocBuilder<RegistrationBloc, RegistrationState>(
            builder: (context, state) {
              if (state is RolesLoaded) {
                return RegisterDropdown<RoleEntity>(
                  label: 'Bạn là ai',
                  value: widget.selectedRole,
                  hintText: 'Chọn vai trò của bạn',
                  items: state.roles
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(DisplayMapper.roleName(r.name)),
                        ),
                      )
                      .toList(),
                  onChanged: (r) => widget.onRoleChanged(r),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          const SizedBox(height: 24),

          if (widget.selectedRole != null) ...[
            if (widget.selectedRole!.name.toLowerCase() == 'student')
              _studentFields(),
            if (widget.selectedRole!.name.toLowerCase() == 'teacher')
              _teacherFields(),
            if (widget.selectedRole!.name.toLowerCase() == 'schooladmin')
              _schoolAdminFields(),
          ],
        ],
      ),
    );
  }

  Widget _studentFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RegisterDropdown<String>(
          label: 'Cấp học',
          value: widget.selectedEducationLevel,
          items: const [
            DropdownMenuItem(value: 'Preschool', child: Text('Mầm non')),
            DropdownMenuItem(value: 'Primary', child: Text('Tiểu học')),
            DropdownMenuItem(
              value: 'Secondary',
              child: Text('Trung học cơ sở'),
            ),
            DropdownMenuItem(
              value: 'HighSchool',
              child: Text('Trung học phổ thông'),
            ),
          ],
          onChanged: (v) => widget.onEducationLevelChanged(v),
        ),
        const SizedBox(height: 16),
        RegisterTextField(
          controller: widget.schoolCodeController,
          label: 'Mã trường học',
          hintText: 'Nhập mã trường để tìm kiếm',
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: AppColors.primary),
            onPressed: () {
              if (widget.schoolCodeController.text.isNotEmpty) {
                context.read<RegistrationBloc>().add(
                  SearchSchoolByCodeEvent(widget.schoolCodeController.text),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        RegisterTextField(
          controller: widget.gradeController,
          label: 'Lớp',
          hintText: 'Ví dụ: 10A1',
        ),
        const SizedBox(height: 16),
        RegisterTextField(
          controller: widget.guardianNameController,
          label: 'Tên phụ huynh',
          hintText: 'Nhập tên phụ huynh',
        ),
        const SizedBox(height: 16),
        RegisterTextField(
          controller: widget.guardianPhoneController,
          label: 'SĐT phụ huynh',
          hintText: 'Nhập số điện thoại phụ huynh',
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _teacherFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RegisterTextField(
          controller: widget.schoolCodeController,
          label: 'Mã trường học',
          hintText: 'Nhập mã trường để tìm kiếm',
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: AppColors.primary),
            onPressed: () {
              if (widget.schoolCodeController.text.isNotEmpty) {
                context.read<RegistrationBloc>().add(
                  SearchSchoolByCodeEvent(widget.schoolCodeController.text),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        RegisterTextField(
          controller: widget.literacyController,
          label: 'Trình độ học vấn',
          hintText: 'Ví dụ: Cử nhân',
        ),
        const SizedBox(height: 16),
        RegisterTextField(
          controller: widget.subjectsController,
          label: 'Môn giảng dạy',
          hintText: 'Các môn, ngăn cách bởi dấu phẩy',
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _schoolAdminFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.extraLightBlue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              RadioListTile<bool>(
                title: const Text('Tham gia trường hiện có'),
                value: false,
                groupValue: widget.isCreateNewSchool,
                onChanged: (v) => widget.onToggleCreateSchool(v ?? false),
                activeColor: AppColors.primary,
              ),
              RadioListTile<bool>(
                title: const Text('Tạo trường mới'),
                value: true,
                groupValue: widget.isCreateNewSchool,
                onChanged: (v) => widget.onToggleCreateSchool(v ?? false),
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (!widget.isCreateNewSchool) ...[
          RegisterTextField(
            controller: widget.schoolCodeController,
            label: 'Mã trường học',
            hintText: 'Nhập mã trường để tìm kiếm',
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: AppColors.primary),
              onPressed: () {
                if (widget.schoolCodeController.text.isNotEmpty) {
                  context.read<RegistrationBloc>().add(
                    SearchSchoolByCodeEvent(widget.schoolCodeController.text),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          RegisterTextField(
            controller: widget.positionController,
            label: 'Chức vụ',
            hintText: 'Nhập chức vụ của bạn',
          ),
        ] else ...[
          Center(
            child: ImagePickerWidget(
              imageFile: _localSchoolLogo,
              onTap: _pickSchoolLogo,
              label: 'Logo trường (không bắt buộc)',
              size: 100,
            ),
          ),
          const SizedBox(height: 16),
          RegisterTextField(
            controller: widget.schoolNameController,
            label: 'Tên trường',
            hintText: 'Nhập tên trường',
          ),
          const SizedBox(height: 16),
          RegisterTextField(
            controller: widget.schoolCodeController,
            label: 'Mã trường',
            hintText: 'Nhập mã trường (duy nhất)',
          ),
          const SizedBox(height: 16),
          RegisterDropdown<String>(
            label: 'Cấp trường',
            value: widget.selectedSchoolLevel,
            items: const [
              DropdownMenuItem(value: 'Preschool', child: Text('Mầm non')),
              DropdownMenuItem(value: 'Primary', child: Text('Tiểu học')),
              DropdownMenuItem(
                value: 'Secondary',
                child: Text('Trung học cơ sở'),
              ),
              DropdownMenuItem(
                value: 'HighSchool',
                child: Text('Trung học phổ thông'),
              ),
            ],
            onChanged: (v) => widget.onSchoolLevelChanged(v),
          ),
          const SizedBox(height: 16),
          RegisterTextField(
            controller: widget.schoolAddressController,
            label: 'Địa chỉ trường',
            hintText: 'Nhập địa chỉ',
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          RegisterTextField(
            controller: widget.schoolPhoneController,
            label: 'SĐT trường',
            hintText: 'Nhập số điện thoại',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          RegisterTextField(
            controller: widget.schoolEmailController,
            label: 'Email trường',
            hintText: 'Nhập email trường',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          RegisterTextField(
            controller: widget.schoolDescriptionController,
            label: 'Mô tả trường',
            hintText: 'Mô tả (không bắt buộc)',
            maxLines: 3,
          ),
        ],
      ],
    );
  }
}
