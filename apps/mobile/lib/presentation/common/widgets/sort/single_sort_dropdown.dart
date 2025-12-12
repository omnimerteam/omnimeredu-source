import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';

class SingleSortDropdownWidget extends StatelessWidget {
  final List<Map<String, String>> currentSort;
  final Map<Map<String, String>, String> sortOptions;
  final ValueChanged<List<Map<String, String>>> onSortChanged;
  final String? placeholder;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const SingleSortDropdownWidget({
    super.key,
    required this.currentSort,
    required this.sortOptions,
    required this.onSortChanged,
    this.placeholder = 'Sắp xếp theo',
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pad = padding ?? EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h);

    return Container(
      width: width,
      padding: pad,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Row(
            children: [
              Icon(
                Icons.sort_rounded,
                size: 18.sp,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              SizedBox(width: 8.w),
              Text(
                placeholder ?? 'Sắp xếp theo',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          items: sortOptions.entries.map((entry) {
            final isSelected =
                currentSort.isNotEmpty &&
                mapEquals(currentSort.first, entry.key);

            return DropdownMenuItem<Map<String, String>>(
              value: entry.key,
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (checked) {
                      if (checked == true) {
                        onSortChanged([entry.key]); // chỉ giữ 1
                      } else {
                        onSortChanged([]); // bỏ chọn hết
                      }
                    },
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300.h,
            width: width != null ? width! + 60.w : null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: theme.colorScheme.surface,
            ),
            elevation: 8,
          ),
          menuItemStyleData: MenuItemStyleData(
            height: 42.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            overlayColor: WidgetStatePropertyAll(
              theme.colorScheme.primary.withOpacity(0.08),
            ),
          ),
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            height: 40.h,
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: theme.colorScheme.primary,
            ),
            iconSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
