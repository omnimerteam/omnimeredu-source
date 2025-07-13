import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/signup/signup_bloc.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/signup/signup_event.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/signup/signup_state.dart';
import 'package:flutter_ios_android_platforms/repositories/auth_repository.dart';
import 'package:flutter_ios_android_platforms/widgets/button/primary_button.dart';
import 'package:flutter_ios_android_platforms/widgets/input/primary_text_field.dart.dart';
import 'package:flutter_ios_android_platforms/widgets/input/primary_dropdown_field.dart';

/// [SignupScreen] là màn hình đăng ký tài khoản.
///
/// Màn hình này sử dụng:
/// - [SignupBloc] để xử lý logic đăng ký.
/// - [BlocConsumer] để lắng nghe state ([SignupState]) và render UI tương ứng.

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  String gender = 'Male';
  String role = 'Student';

  final Map<String, String> roleLabels = {
    'SuperAdmin': 'Quản trị viên cấp cao',
    'SchoolAdmin': 'Quản trị viên trường',
    'Teacher': 'Giáo viên',
    'Student': 'Học sinh',
    'CanteenStaff': 'Nhân viên căng tin',
    'Nurse': 'Y tá',
    'Security': 'Bảo vệ',
  };

  final Map<String, String> genderLabels = {
    'Male': 'Nam',
    'Female': 'Nữ',
    'Other': 'Khác',
  };

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(authRepository: AuthRepository()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<SignupBloc, SignupState>(
              listener: (context, state) {
                if (state is SignupSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Register successful')),
                  );
                  Navigator.pushReplacementNamed(context, '/login');
                } else if (state is SignupFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      'Tạo tài khoản',
                      style: TextStyle(
                        color: Color(0xFF1E88E5),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      label: 'Họ và tên',
                      controller: fullNameController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Email',
                      controller: emailController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Số điện thoại',
                      controller: phoneController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Mật khẩu',
                      controller: passwordController,
                      isObscure: true,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Xác nhận mật khẩu',
                      controller: rePasswordController,
                      isObscure: true,
                    ),
                    const SizedBox(height: 16),
                    CustomDropdownField(
                      label: 'Giới tính',
                      value: gender,
                      items: genderLabels,
                      onChanged: (value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomDropdownField(
                      label: 'Bạn là',
                      value: role,
                      items: roleLabels,
                      onChanged: (value) {
                        setState(() {
                          role = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    if (state is SignupLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      PrimaryButton(
                        label: 'Tạo tài khoản',
                        onPressed: () {
                          context.read<SignupBloc>().add(
                            SignupSubmitted(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              rePassword: rePasswordController.text.trim(),
                              fullName: fullNameController.text.trim(),
                              gender: gender,
                              phone: phoneController.text.trim(),
                              role: role,
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text('Đã có tài khoản? Đăng nhập'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
