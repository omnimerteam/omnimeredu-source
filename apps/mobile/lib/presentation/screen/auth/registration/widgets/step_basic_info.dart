import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/presentation/common/widgets/input/app_image_picker.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../common/widgets/input/primary_text_field.dart';
import '../../../../common/widgets/input/primary_dropdown.dart';
import '../../../../../../core/validation/field_validator.dart';
import '../bloc/registration_bloc.dart';
import '../bloc/registration_event.dart';
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

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _birthdayFocus = FocusNode();

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

    _emailFocus.addListener(_onFocusChange);
    _passwordFocus.addListener(_onFocusChange);
    _confirmPasswordFocus.addListener(_onFocusChange);
    _fullNameFocus.addListener(_onFocusChange);
    _phoneFocus.addListener(_onFocusChange);
    _addressFocus.addListener(_onFocusChange);
    _birthdayFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();

    _emailFocus.removeListener(_onFocusChange);
    _passwordFocus.removeListener(_onFocusChange);
    _confirmPasswordFocus.removeListener(_onFocusChange);
    _fullNameFocus.removeListener(_onFocusChange);
    _phoneFocus.removeListener(_onFocusChange);
    _addressFocus.removeListener(_onFocusChange);
    _birthdayFocus.removeListener(_onFocusChange);

    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _fullNameFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
    _birthdayFocus.dispose();

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
          PrimaryTextField(
            controller: _emailController,
            focusNode: _emailFocus,
            isFocused: _emailFocus.hasFocus,
            hintText: 'Nhập email của bạn',
            prefixIcon: Icons.email_outlined,
            required: true,
            keyboardType: TextInputType.emailAddress,
            validator: FieldValidators.email(fieldName: 'Email'),
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateBasicInfoEvent(email: v),
            ),
          ),
          SizedBox(height: 16.h),

          /// Password
          PrimaryTextField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            isFocused: _passwordFocus.hasFocus,
            hintText: 'Nhập mật khẩu',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            required: true,
            validator: FieldValidators.password(),
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateBasicInfoEvent(password: v),
            ),
          ),
          SizedBox(height: 16.h),

          /// Confirm password
          PrimaryTextField(
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocus,
            isFocused: _confirmPasswordFocus.hasFocus,
            hintText: 'Nhập lại mật khẩu',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            required: true,
            validator: FieldValidators.confirmPassword(
              _passwordController.text,
            ),
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateBasicInfoEvent(confirmPassword: v),
            ),
          ),
          SizedBox(height: 16.h),

          /// Full name
          PrimaryTextField(
            controller: _fullNameController,
            focusNode: _fullNameFocus,
            isFocused: _fullNameFocus.hasFocus,
            hintText: 'Nhập họ và tên',
            prefixIcon: Icons.person_outline,
            required: true,
            validator: FieldValidators.fullname(),
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateBasicInfoEvent(fullName: v),
            ),
          ),
          SizedBox(height: 16.h),

          /// Gender
          PrimaryDropdown<String>(
            value: state.gender,
            isFocused:
                false, // Dropdown handles its own focus visually mostly or we can add a fake focus node if needed? PrimaryDropdown doesn't seem to take a FocusNode but has an isFocused param.
            // Since PrimaryDropdown wraps DropdownButtonFormField, focus handling is a bit different. Let's assume false for now or unimplemented for focus color.
            hintText: 'Giới tính',
            prefixIcon: Icons.people_outline,
            items: GenderEnum.values.map((gender) {
              return DropdownMenuItem<String>(
                value: gender.name,
                child: Text(gender.displayName),
              );
            }).toList(),
            onChanged: (v) {
              if (v != null) {
                context.read<RegistrationBloc>().add(
                  UpdateBasicInfoEvent(gender: v),
                );
              }
            },
            required: true,
            validator: FieldValidators.required(fieldName: 'Giới tính'),
          ),
          SizedBox(height: 16.h),

          /// Phone
          PrimaryTextField(
            controller: _phoneController,
            focusNode: _phoneFocus,
            isFocused: _phoneFocus.hasFocus,
            hintText: 'Nhập số điện thoại',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            required: true,
            validator: FieldValidators.phone(),
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateBasicInfoEvent(phone: v),
            ),
          ),
          SizedBox(height: 16.h),

          /// Birthday
          GestureDetector(
            onTap: _pickBirthday,
            child: AbsorbPointer(
              child: PrimaryTextField(
                controller: TextEditingController(
                  text: state.birthday != null
                      ? "${state.birthday!.day}/${state.birthday!.month}/${state.birthday!.year}"
                      : '',
                ),
                focusNode: _birthdayFocus, // Fake focus
                isFocused: _birthdayFocus.hasFocus,
                hintText: 'Chọn ngày sinh',
                prefixIcon: Icons.calendar_today,
                readOnly: true,
                required: false,
              ),
            ),
          ),
          SizedBox(height: 16.h),

          /// Address
          PrimaryTextField(
            controller: _addressController,
            focusNode: _addressFocus,
            isFocused: _addressFocus.hasFocus,
            hintText: 'Nhập địa chỉ',
            prefixIcon: Icons.location_on_outlined,
            onChanged: (v) => context.read<RegistrationBloc>().add(
              UpdateBasicInfoEvent(address: v),
            ),
            validator: FieldValidators.address(),
            required: false,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
