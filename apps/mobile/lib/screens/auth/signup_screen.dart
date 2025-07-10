import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/signup/signup_bloc.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/signup/signup_event.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/signup/signup_state.dart';
import 'package:flutter_ios_android_platforms/repositories/auth_repository.dart';
import 'package:flutter_ios_android_platforms/widgets/button/primary_button.dart';
import 'package:flutter_ios_android_platforms/widgets/textField/custom_text_field.dart.dart';

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
                      'Create Account',
                      style: TextStyle(
                        color: Color(0xFF1E88E5),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      label: 'Full Name',
                      controller: fullNameController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Email',
                      controller: emailController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Phone',
                      controller: phoneController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Password',
                      controller: passwordController,
                      isObscure: true,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Re-enter Password',
                      controller: rePasswordController,
                      isObscure: true,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: gender,
                      items: ['Male', 'Female', 'Other']
                          .map(
                            (g) => DropdownMenuItem(value: g, child: Text(g)),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => gender = value!),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFD0E6FF),
                        labelText: 'Gender',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: role,
                      items:
                          [
                                'SuperAdmin',
                                'SchoolAdmin',
                                'Teacher',
                                'Student',
                                'CanteenStaff',
                                'Nurse',
                                'Security',
                              ]
                              .map(
                                (r) =>
                                    DropdownMenuItem(value: r, child: Text(r)),
                              )
                              .toList(),
                      onChanged: (value) => setState(() => role = value!),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFD0E6FF),
                        labelText: 'Role',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (state is SignupLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      PrimaryButton(
                        label: 'Sign Up',
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
                        child: const Text('Already have an account? Sign In'),
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
