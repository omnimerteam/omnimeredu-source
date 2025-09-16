import 'package:flutter/material.dart';

/// Loại button hỗ trợ sẵn
enum AppButtonType { primary, secondary, success, danger }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool loading;
  final bool fullWidth;
  final AppButtonType type;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.fullWidth = true,
    this.type = AppButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 🎨 Xác định màu theo type
    Color background;
    Color foreground;
    switch (type) {
      case AppButtonType.primary: // Submit
        background = colorScheme.primary;
        foreground = colorScheme.onPrimary;
        break;
      case AppButtonType.secondary: // Cancel
        background = Colors.grey.shade600;
        foreground = Colors.white;
        break;
      case AppButtonType.success: // Update / Approve
        background = Colors.green;
        foreground = Colors.white;
        break;
      case AppButtonType.danger: // Delete / Reject
        background = Colors.red;
        foreground = Colors.white;
        break;
    }

    // Nội dung
    final buttonChild = loading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(foreground),
            ),
          )
        : Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          );

    // Nút chính
    final button = ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        backgroundColor: background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: buttonChild,
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
