import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class AlreadyHaveAccount extends StatelessWidget {
  final VoidCallback onLoginTap;

  const AlreadyHaveAccount({Key? key, required this.onLoginTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Đã có tài khoản? "),
        TextButton(
          onPressed: onLoginTap,
          child: const Text(
            "Đăng nhập",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
