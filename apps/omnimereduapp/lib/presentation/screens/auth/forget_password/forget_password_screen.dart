import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import 'bloc/forget_password_bloc.dart';
import 'bloc/forget_password_event.dart';
import 'bloc/forget_password_state.dart';
import '../../../widgets/common/action_snack_bar.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _onSendResetEmail(BuildContext context) {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showActionSnackBar(
        context: context,
        message: "Vui lòng nhập email",
        lastActionSuccess: false,
      );
      return;
    }
    context.read<ForgetPasswordBloc>().add(SendResetEmailEvent(email));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
      listener: (context, state) {
        // Dùng chung helper
        if (state.success || state.error != null) {
          showActionSnackBar(
            context: context,
            message: state.success
                ? "📨 Đã gửi email khôi phục mật khẩu. Vui lòng kiểm tra hộp thư."
                : state.error ?? "Có lỗi xảy ra",
            lastActionSuccess: state.success,
          );
        }

        if (state.success) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Quên mật khẩu")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Nhập email để nhận liên kết đặt lại mật khẩu:",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state.loading
                      ? null
                      : () => _onSendResetEmail(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: state.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Gửi email khôi phục",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
