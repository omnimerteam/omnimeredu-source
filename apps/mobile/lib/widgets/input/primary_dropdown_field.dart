import 'package:flutter/material.dart';

/// [CustomDropdownField] là dropdown tái sử dụng.
/// Cho phép tuỳ chỉnh label, value, items, onChanged.
/// Nền: trắng, border: xanh, bo góc 12.
class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.entries
          .map(
            (entry) =>
                DropdownMenuItem(value: entry.key, child: Text(entry.value)),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white, // Nền trắng
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF1E88E5), // Border xanh
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF1E88E5), // Border xanh
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF1E88E5), // Border xanh
            width: 2,
          ),
        ),
      ),
    );
  }
}
