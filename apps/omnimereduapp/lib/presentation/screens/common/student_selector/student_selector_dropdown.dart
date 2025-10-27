import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/student_selector_cubit.dart';
import 'cubit/student_selector_state.dart';

class StudentSelectorDropdown extends StatelessWidget {
  final String? selectedStudentId;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;
  final String hintText;
  final bool isFocused;

  const StudentSelectorDropdown({
    super.key,
    this.selectedStudentId,
    this.onChanged,
    this.validator,
    this.hintText = 'Chọn học sinh',
    this.isFocused = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<StudentSelectorCubit, StudentSelectorState>(
      builder: (context, state) {
        List<DropdownMenuItem<String>> items = _buildDropdownItems(
          state,
          context,
        );

        return DropdownButtonFormField<String>(
          value: selectedStudentId,
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
                Icons.person,
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
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
          ),
          items: items,
          onChanged: onChanged,
          validator: validator,
          icon: state is StudentSelectorLoading
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                      theme.colorScheme.primary,
                    ),
                  ),
                )
              : Icon(
                  Icons.keyboard_arrow_down,
                  color: isDark ? Colors.grey[300] : const Color(0xFF64748B),
                ),
        );
      },
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(
    StudentSelectorState state,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (state is StudentSelectorSuccess) {
      return state.students
          .map(
            (student) => DropdownMenuItem<String>(
              value: student.id,
              child: Text(
                student.fullName,
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  color: isDark ? Colors.grey[100] : Colors.black87,
                ),
              ),
            ),
          )
          .toList();
    } else if (state is StudentSelectorError) {
      return [
        DropdownMenuItem<String>(
          value: null,
          enabled: false,
          child: Text(
            'Lỗi: ${state.message}',
            style: TextStyle(
              color: isDark ? Colors.red[300] : Colors.red,
              fontSize: 14,
              fontFamily: "Inter",
            ),
          ),
        ),
      ];
    }
    return [];
  }

  Color _getFillColor(BuildContext context, bool isFocused, bool isDark) {
    final theme = Theme.of(context);
    if (isFocused) return theme.colorScheme.primary.withOpacity(0.05);
    return isDark ? Colors.grey[800]! : const Color(0xFFF8FAFC);
  }
}
