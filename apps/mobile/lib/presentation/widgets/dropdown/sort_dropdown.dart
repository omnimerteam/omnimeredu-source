import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SortDropdownWidget extends StatelessWidget {
  final String currentSort;
  final Map<String, String> sortOptions;
  final ValueChanged<String> onSortChanged;
  final String? placeholder;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const SortDropdownWidget({
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
        child: DropdownButton2<String>(
          value: sortOptions.containsKey(currentSort) ? currentSort : null,
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
            final isSelected = entry.key == currentSort;
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Row(
                children: [
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  else
                    const SizedBox(width: 16),
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
          onChanged: (value) {
            if (value != null) onSortChanged(value);
          },

          // 🔥 popup menu
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300,
            width: width != null ? width! + 60 : null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surface,
            ),
            elevation: 8,
          ),

          // 🔥 style cho từng item trong menu
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
