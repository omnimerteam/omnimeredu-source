import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/routing/route_config.dart';

class AlreadyHaveAccount extends StatelessWidget {
  const AlreadyHaveAccount({super.key, this.onLoginTap});

  final VoidCallback? onLoginTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Đã có tài khoản? "),
        TextButton(
          onPressed: () {
            if (onLoginTap != null) {
              onLoginTap!();
            } else {
              RouteConfig.navigateToLogin(context);
            }
          },
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
