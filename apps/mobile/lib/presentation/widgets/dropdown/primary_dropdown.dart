import 'package:flutter/material.dart';

class PrimaryDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String hintText;
  final IconData prefixIcon;
  final bool isFocused;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool required; // 🔹 thêm thuộc tính

  const PrimaryDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.prefixIcon,
    this.isFocused = false,
    this.onChanged,
    this.validator,
    this.required = false, // 🔹 default = false
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
          dropdownColor: isDark ? Colors.grey[800] : Colors.white,
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onBackground,
          ),
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
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
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
          items: items,
          onChanged: onChanged,
          validator: (value) {
            final error = validator?.call(value);
            if (error != null && error.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final messenger = ScaffoldMessenger.of(context);
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text("$hintText: $error"),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
              });
            }
            // 🔹 nếu required = true và value null thì báo lỗi
            if (required && value == null) return 'Chọn $hintText';
            return error;
          },
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: isDark ? Colors.grey[300] : const Color(0xFF64748B),
          ),
        ),

        // 🔹 Chấm đỏ nếu required = true
        if (required)
          Positioned(
            top: 11,
            left: 9,
            child: Container(
              width: 11,
              height: 11,
              decoration: const BoxDecoration(
                color: Colors.red,
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
    return isDark ? Colors.grey[800]! : const Color(0xFFF8FAFC);
  }
}
