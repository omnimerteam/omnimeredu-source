import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/display_mapper.dart';
import '../../../../utils/validator.dart';
import '../bloc/registration_event.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../widgets/dropdown/register_dropdown.dart';
import '../../../../widgets/image_picker/app_image_picker.dart';
import '../../../../widgets/text_field/register_text_field.dart';
import '../bloc/registration_bloc.dart';
import '../bloc/registration_state.dart';

class StepBasicInfo extends StatefulWidget {
  final RegistrationState state;

  const StepBasicInfo({super.key, required this.state});

  @override
  State<StepBasicInfo> createState() => _StepBasicInfoState();
}

class _StepBasicInfoState extends State<StepBasicInfo> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.state.email);
    _passwordController = TextEditingController(text: widget.state.password);
    _confirmPasswordController = TextEditingController(
      text: widget.state.confirmPassword,
    );
    _fullNameController = TextEditingController(text: widget.state.fullName);
    _phoneController = TextEditingController(text: widget.state.phone);
    _addressController = TextEditingController(text: widget.state.address);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      context.read<RegistrationBloc>().add(
        UpdateBasicInfoEvent(avatarFile: File(picked.path)),
      );
    }
  }

  Future<void> _pickBirthday() async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          widget.state.birthday ??
          DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      context.read<RegistrationBloc>().add(
        UpdateBasicInfoEvent(birthday: date),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar
          Center(
            child: ImagePickerWidget(
              imageFile: state.avatarFile,
              onTap: _pickImage,
              label: 'Chọn ảnh đại diện',
              size: 120.w,
            ),
          ),
          SizedBox(height: 24.h),

          /// Email
          RegisterTextField(
            controller: _emailController,
            label: 'Email',
            hintText: 'Nhập email của bạn',
            requiredInput: true,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateBasicInfoEvent(email: v),
            ),
          ),
          SizedBox(height: 16.h),

          /// Password
          RegisterTextField(
            controller: _passwordController,
            label: 'Mật khẩu',
            hintText: 'Nhập mật khẩu',
            isPassword: true,
            requiredInput: true,
            validator: Validators.password,
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateBasicInfoEvent(password: v),
            ),
          ),
          SizedBox(height: 16.h),

          /// Confirm password
          RegisterTextField(
            controller: _confirmPasswordController,
            label: 'Xác nhận mật khẩu',
            hintText: 'Nhập lại mật khẩu',
            isPassword: true,
            requiredInput: true,
            validator: (v) =>
                Validators.confirmPassword(v, _passwordController.text),
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateBasicInfoEvent(confirmPassword: v),
            ),
          ),
          SizedBox(height: 16.h),

          /// Full name
          RegisterTextField(
            controller: _fullNameController,
            label: 'Họ và tên',
            hintText: 'Nhập họ và tên',
            requiredInput: true,
            validator: (v) =>
                Validators.requiredField(v, name: "Họ và tên") ??
                Validators.name(v),
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateBasicInfoEvent(fullName: v),
            ),
          ),
          SizedBox(height: 16.h),

          /// Gender
          RegisterDropdown<String>(
            label: 'Giới tính',
            value: state.gender,
            items: DisplayMapper.gender.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateBasicInfoEvent(gender: v),
            ),
          ),
          SizedBox(height: 16.h),

          /// Phone
          RegisterTextField(
            controller: _phoneController,
            label: 'Số điện thoại',
            hintText: 'Nhập số điện thoại',
            keyboardType: TextInputType.phone,
            validator: (v) =>
                Validators.requiredField(v, name: "Số điện thoại") ??
                Validators.phone(v),
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateBasicInfoEvent(phone: v),
            ),
          ),
          SizedBox(height: 16.h),

          /// Birthday
          GestureDetector(
            onTap: _pickBirthday,
            child: AbsorbPointer(
              child: RegisterTextField(
                controller: TextEditingController(
                  text: state.birthday != null
                      ? "${state.birthday!.day}/${state.birthday!.month}/${state.birthday!.year}"
                      : '',
                ),
                label: 'Ngày sinh',
                hintText: 'Chọn ngày sinh',
                readOnly: true,
                suffixIcon: const Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          /// Address
          RegisterTextField(
            controller: _addressController,
            label: 'Địa chỉ',
            hintText: 'Nhập địa chỉ',
            maxLines: 2,
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateBasicInfoEvent(address: v),
            ),
            validator: (v) => Validators.address(v),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
