import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/login/login_bloc.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/login/login_event.dart';
import 'package:flutter_ios_android_platforms/blocs/auth/login/login_state.dart';
import 'package:flutter_ios_android_platforms/repositories/auth_repository.dart';
import 'package:flutter_ios_android_platforms/widgets/button/primary_button.dart';
import 'package:flutter_ios_android_platforms/widgets/input/primary_text_field.dart.dart';

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
      create: (_) => LoginBloc(
        authRepository: context.read<AuthRepository>(),
        authenticationBloc: context.read<AuthenticationBloc>(),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Chào mừng ${state.role}!')),
                  );
                } else if (state is LoginFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          /// LOGO - Bạn có thể thay đổi link ảnh sau
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/logo.jpg',
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'OmniMer EDU',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    CustomTextField(
                      label: 'Email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      label: 'Mật khẩu',
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
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
                        child: const Text(
                          'Chưa có tài khoản? Đăng ký',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
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
