import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';

class PrimaryTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData prefixIcon;
  final bool isFocused;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged; // 👈 thêm mới

  const PrimaryTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.prefixIcon,
    required this.isFocused,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onChanged, // 👈 thêm mới
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        onChanged: onChanged, // 👈 gắn vào đây
        style: const TextStyle(
          fontFamily: "Inter",
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1E293B),
        ),
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
          suffixIcon: suffixIcon,
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
      ),
    );
  }
}
