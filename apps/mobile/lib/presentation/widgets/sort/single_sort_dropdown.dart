import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart'; // mapEquals

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
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Row(
            children: [
              Icon(
                Icons.sort_rounded,
                size: 18,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                placeholder ?? 'Sắp xếp theo',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
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
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
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
            maxHeight: 300,
            width: width != null ? width! + 60 : null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surface,
            ),
            elevation: 8,
          ),
          menuItemStyleData: MenuItemStyleData(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            overlayColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.primary.withOpacity(0.08),
            ),
          ),
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 8),
            height: 40,
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            iconSize: 18,
          ),
        ),
      ),
    );
  }
}
