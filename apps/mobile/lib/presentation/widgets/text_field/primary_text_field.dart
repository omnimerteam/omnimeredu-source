import 'package:flutter/material.dart';

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
  final ValueChanged<String>? onChanged;

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
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: TextStyle(
          fontFamily: "Inter",
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onBackground,
        ),
        validator: (value) {
          final error = validator?.call(value);

          if (error != null && error.isNotEmpty) {
            // 🔹 show SnackBar khi có lỗi
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final messenger = ScaffoldMessenger.of(context);
              messenger.hideCurrentSnackBar(); // tránh chồng nhiều snackbar
              messenger.showSnackBar(
                SnackBar(
                  content: Text("$hintText: $error"),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
            });
          }

          return error; // vẫn hiện errorText dưới input
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[400] : const Color(0xFF94A3B8),
            fontFamily: "Inter",
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: _getFillColor(context, isFocused, isDark),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isFocused
                  ? theme.colorScheme.primary
                  : (isDark ? Colors.grey[700] : const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              prefixIcon,
              color: isFocused
                  ? theme.colorScheme.onPrimary
                  : (isDark ? Colors.grey[300] : const Color(0xFF64748B)),
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
            borderSide: BorderSide(
              color: isDark ? Colors.grey[600]! : const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
        ),
      ),
    );
  }

  Color _getFillColor(BuildContext context, bool isFocused, bool isDark) {
    final theme = Theme.of(context);

    if (isFocused) {
      return theme.colorScheme.primary.withOpacity(0.05);
    }

    return isDark ? Colors.grey[800]! : const Color(0xFFF8FAFC);
  }
}
