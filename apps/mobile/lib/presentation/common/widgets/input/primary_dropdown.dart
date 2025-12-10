import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class PrimaryDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String hintText;
  final IconData prefixIcon;
  final bool isFocused;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool required;

  const PrimaryDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.prefixIcon,
    this.isFocused = false,
    this.onChanged,
    this.validator,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        DropdownButtonFormField<T>(
          isExpanded: true,
          value: value,
          dropdownColor: isDark ? AppColors.grey800 : Colors.white,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onBackground,
          ),
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
          items: items,
          onChanged: onChanged,
          validator: (value) {
            final error = validator?.call(value);
            if (required && value == null) return 'Chọn $hintText';
            return error;
          },
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: isDark ? AppColors.grey300 : const Color(0xFF64748B),
            size: 24.sp,
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
    final theme = Theme.of(context);
    if (isFocused) {
      return theme.colorScheme.primary.withOpacity(0.05);
    }
    return isDark ? AppColors.grey800 : const Color(0xFFF8FAFC);
  }
}
