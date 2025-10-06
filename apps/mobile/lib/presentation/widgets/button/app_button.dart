import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';

/// Các loại button hỗ trợ sẵn
enum AppButtonType { primary, secondary, success, danger, cancel }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final bool fullWidth;
  final double? width; // 👈 thêm width tuỳ chọn
  final AppButtonType type;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
    this.fullWidth = true,
    this.width,
    this.type = AppButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 🎨 Màu sắc theo type
    Color background;
    Color foreground;
    switch (type) {
      case AppButtonType.primary:
        background = colorScheme.primary;
        foreground = colorScheme.onPrimary;
        break;
      case AppButtonType.secondary:
        background = colorScheme.secondary;
        foreground = colorScheme.onSecondary;
        break;
      case AppButtonType.cancel:
        background = Colors.transparent; // 👈 outliner ko cần nền
        foreground = Colors.grey.shade700;
        break;
      case AppButtonType.success:
        background = AppColors.approvedColor;
        foreground = Colors.white;
        break;
      case AppButtonType.danger:
        background = colorScheme.error;
        foreground = Colors.white;
        break;
    }

    // Nội dung nút
    final buttonChild = loading
        ? SizedBox(
            height: 18,
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

    // 🔹 cancel => OutlinedButton
    final button = (type == AppButtonType.cancel)
        ? OutlinedButton(
            onPressed: (loading || onPressed == null) ? null : onPressed,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: foreground,
              side: BorderSide(color: foreground, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: (loading || onPressed == null) ? null : onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: background,
              foregroundColor: foreground,
              disabledBackgroundColor: background.withOpacity(0.5),
              disabledForegroundColor: foreground.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: buttonChild,
          );

    // Wrap theo width
    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    } else if (width != null) {
      return SizedBox(width: width, child: button);
    } else {
      return button;
    }
  }
}
