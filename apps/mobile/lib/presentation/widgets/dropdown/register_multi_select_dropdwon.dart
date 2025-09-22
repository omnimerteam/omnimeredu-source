import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class RegisterDropdownMultiSelect<T> extends StatelessWidget {
  final String label;
  final List<T> selectedValues;
  final List<MultiSelectItem<T>> items;
  final ValueChanged<List<T>> onChanged;
  final String? Function(List<T>?)? validator;
  final String? hintText;
  final bool requiredInput;

  const RegisterDropdownMultiSelect({
    super.key,
    required this.label,
    required this.items,
    required this.selectedValues,
    required this.onChanged,
    this.validator,
    this.hintText,
    this.requiredInput = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
            if (requiredInput) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.red,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        MultiSelectDialogField<T>(
          items: items,
          initialValue: selectedValues,
          onConfirm: (values) => onChanged(values),
          validator: validator,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          buttonText: Text(
            hintText ?? 'Chọn ${label.toLowerCase()}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          buttonIcon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.primary,
          ),
          chipDisplay: MultiSelectChipDisplay(
            chipColor: AppColors.primary.withOpacity(0.2),
            textStyle: const TextStyle(color: AppColors.primary),
            onTap: (item) {
              final newList = List<T>.from(selectedValues)..remove(item);
              onChanged(newList);
            },
          ),
        ),
      ],
    );
  }
}
