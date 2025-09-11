import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';

class PrimaryDropdown extends StatelessWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items; // 👈 thay đổi
  final String hintText;
  final IconData prefixIcon;
  final bool isFocused;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const PrimaryDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.prefixIcon,
    this.isFocused = false,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF94A3B8),
          fontFamily: "Inter",
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: isFocused
            ? AppColors.primary.withOpacity(0.05)
            : const Color(0xFFF8FAFC),
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isFocused ? AppColors.primary : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            prefixIcon,
            color: isFocused ? Colors.white : const Color(0xFF64748B),
            size: 20,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
      ),
      items: items, // 👈 nhận trực tiếp từ ngoài
      onChanged: onChanged,
      validator: validator,
    );
  }
}
