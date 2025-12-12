import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

/// Các loại button hỗ trợ sẵn
enum AppButtonType { primary, secondary, success, danger, cancel }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final bool fullWidth;
  final double? width;
  final AppButtonType type;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
    this.fullWidth = true,
    this.width,
    this.type = AppButtonType.primary,
    this.icon,
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
        background = Colors.transparent;
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
            height: 20.h,
            width: 20.h,
            child: CircularProgressIndicator(
              strokeWidth: 2.5.w,
              valueColor: AlwaysStoppedAnimation<Color>(
                (type == AppButtonType.cancel)
                    ? colorScheme.primary
                    : foreground,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20.sp, color: foreground),
                SizedBox(width: 8.w),
              ],
              Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: foreground,
                  fontSize: 16.sp,
                ),
              ),
            ],
          );

    // Style chung
    final buttonStyle = (type == AppButtonType.cancel)
        ? OutlinedButton.styleFrom(
            minimumSize: Size.fromHeight(52.h),
            foregroundColor: foreground,
            side: BorderSide(color: foreground, width: 1.5.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          )
        : ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(52.h),
            backgroundColor: background,
            foregroundColor: foreground,
            disabledBackgroundColor: background.withOpacity(0.5),
            disabledForegroundColor: foreground.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          );

    final button = (type == AppButtonType.cancel)
        ? OutlinedButton(
            onPressed: (loading || onPressed == null) ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: (loading || onPressed == null) ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          );

    // Wrap theo width
    if (fullWidth && width == null) {
      return SizedBox(width: double.infinity, child: button);
    } else if (width != null) {
      return SizedBox(width: width, child: button);
    } else {
      return button;
    }
  }
}
