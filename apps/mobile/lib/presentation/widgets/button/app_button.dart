import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../../core/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool loading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GFButton(
      onPressed: loading ? null : onPressed,
      text: text,
      size: GFSize.LARGE,
      color: AppColors.primary,
      fullWidthButton: true,
      blockButton: true,
      child: loading ? const GFLoader(type: GFLoaderType.circle) : null,
    );
  }
}
