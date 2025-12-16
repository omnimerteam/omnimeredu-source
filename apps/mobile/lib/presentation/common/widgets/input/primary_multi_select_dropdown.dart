import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../../core/theme/app_colors.dart';

class PrimaryMultiSelectDropdown<T> extends StatelessWidget {
  final List<T> selectedValues;
  final List<MultiSelectItem<T>> items;
  final String hintText;
  final IconData prefixIcon;
  final Function(List<T>) onChanged;
  final String? Function(List<T>?)? validator;
  final bool required;
  final String title;

  const PrimaryMultiSelectDropdown({
    super.key,
    required this.selectedValues,
    required this.items,
    required this.hintText,
    required this.prefixIcon,
    required this.onChanged,
    this.validator,
    this.required = false,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FormField<List<T>>(
      initialValue: selectedValues,
      validator: validator,
      builder: (FormFieldState<List<T>> state) {
        final isError = state.hasError;
        // We can't easily track "focus" state without a FocusNode and interaction,
        // but for a dialog trigger, "focused" usually means the dialog is open.
        // For simplicity, we'll treat it as unfocused unless we add state management for openings.
        // Or we can just use the standard "enabled" look.
        const isFocused = false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                InkWell(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (ctx) {
                        return MultiSelectDialog<T>(
                          items: items,
                          initialValue: selectedValues,
                          onConfirm: (values) {
                            state.didChange(values);
                            onChanged(values);
                          },
                          title: Text(title),
                          searchable: true,
                          selectedColor: theme.colorScheme.primary,
                          confirmText: Text(
                            "OK",
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                          cancelText: Text(
                            "Hủy",
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getFillColor(context, isFocused, isDark),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isError
                            ? theme.colorScheme.error
                            : (isDark
                                  ? AppColors.grey600
                                  : const Color(0xFFE2E8F0)),
                        width: isError
                            ? 1.w
                            : 1.w, // Match PrimaryDropdown borders roughly
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 20.h,
                      horizontal: 20.w,
                    ),
                    child: Row(
                      children: [
                        // Prefix Icon
                        Container(
                          margin: EdgeInsets.only(right: 12.w),
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: isFocused
                                ? theme.colorScheme.primary
                                : (isDark
                                      ? AppColors.grey700
                                      : const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            prefixIcon,
                            color: isFocused
                                ? theme.colorScheme.onPrimary
                                : (isDark
                                      ? AppColors.grey300
                                      : const Color(0xFF64748B)),
                            size: 20.sp,
                          ),
                        ),

                        // Text Content
                        Expanded(
                          child: Text(
                            selectedValues.isNotEmpty
                                ? items
                                      .where(
                                        (element) => selectedValues.contains(
                                          element.value,
                                        ),
                                      )
                                      .map((e) => e.label)
                                      .join(", ")
                                : hintText,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: selectedValues.isNotEmpty
                                  ? theme.colorScheme.onBackground
                                  : (isDark
                                        ? AppColors.grey400
                                        : const Color(0xFF94A3B8)),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Suffix Icon (Arrow down)
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: isDark
                              ? AppColors.grey300
                              : const Color(0xFF64748B),
                          size: 24.sp,
                        ),
                      ],
                    ),
                  ),
                ),

                // Required Indicator
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
            ),

            // Error Message
            if (isError)
              Padding(
                padding: EdgeInsets.only(top: 8.h, left: 16.w),
                child: Text(
                  state.errorText ?? "",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
          ],
        );
      },
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
