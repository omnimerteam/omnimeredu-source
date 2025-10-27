// lib/presentation/widgets/app_text_field.dart
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../../core/theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscure = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return GFTextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.primary),
      ),
      validatornew: validator,
    );
  }
}
