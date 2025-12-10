import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/theme/app_colors.dart';

class PrimaryTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData prefixIcon;
  final bool isFocused;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool required;

  const PrimaryTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.prefixIcon,
    required this.isFocused,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onTap,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            readOnly: readOnly,
            onTap: onTap,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            validator: (value) {
              final error = validator?.call(value);
              // Standard validator behavior
              return error;
            },
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.grey400 : const Color(0xFF94A3B8),
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: _getFillColor(context, isFocused, isDark),
              prefixIcon: Container(
                margin: EdgeInsets.all(12.w),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isFocused
                      ? theme.colorScheme.primary
                      : (isDark ? AppColors.grey700 : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  prefixIcon,
                  color: isFocused
                      ? theme.colorScheme.onPrimary
                      : (isDark ? AppColors.grey300 : const Color(0xFF64748B)),
                  size: 20.sp,
                ),
              ),
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: isDark ? AppColors.grey600 : const Color(0xFFE2E8F0),
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2.w,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                  width: 2.w,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                  width: 2.w,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 20.h,
                horizontal: 20.w,
              ),
            ),
          ),
        ),
        if (required)
          Positioned(
            top: 11.h,
            left: 9.w,
            child: Container(
              width: 11.w,
              height: 11.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Color _getFillColor(BuildContext context, bool isFocused, bool isDark) {
    if (isFocused) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.05);
    }
    return isDark ? AppColors.grey800 : const Color(0xFFF8FAFC);
  }
}
