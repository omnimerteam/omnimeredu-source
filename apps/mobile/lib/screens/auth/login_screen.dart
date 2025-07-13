import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/login/login_bloc.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/login/login_event.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/login/login_state.dart';
import 'package:flutter_ios_android_platforms/controller/auth.controller.dart';
import 'package:flutter_ios_android_platforms/repositories/auth_repository.dart';
import 'package:flutter_ios_android_platforms/widgets/button/primary_button.dart';
import 'package:flutter_ios_android_platforms/widgets/input/primary_text_field.dart.dart';

/// [LoginScreen] là màn hình đăng nhập chính.
///
/// Màn hình này sử dụng:
/// - BLoC pattern ([LoginBloc]) để xử lý logic đăng nhập.
/// - BlocConsumer để listen & build UI theo [LoginState].
///
/// Điều hướng:
/// - Nếu chưa có tài khoản, cho phép chuyển sang màn hình đăng ký (/signup).

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(authRepository: AuthRepository()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  // Hiển thị SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Welcome ${state.role}!')),
                  );
                  // 👉 Điều hướng theo role
                  AuthController.navigateToHomeByRole(context, state.role);
                } else if (state is LoginFailure) {
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
                      'Welcome Back',
                      style: TextStyle(
                        color: Color(0xFF1E88E5),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      label: 'Email',
                      controller: emailController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Mật khẩu',
                      controller: passwordController,
                      isObscure: true,
                    ),
                    const SizedBox(height: 32),
                    if (state is LoginLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      PrimaryButton(
                        label: 'Đăng nhập',
                        onPressed: () {
                          context.read<LoginBloc>().add(
                            LoginSubmitted(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/signup'),
                        child: const Text('Chưa có tài khoản? Đăng ký'),
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
