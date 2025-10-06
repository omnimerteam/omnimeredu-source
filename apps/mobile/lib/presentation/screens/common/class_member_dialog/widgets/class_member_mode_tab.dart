import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/bloc/class_member_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/bloc/class_member_event.dart';

class ClassMemberModeTabs extends StatelessWidget {
  final ClassMemberMode currentMode;

  const ClassMemberModeTabs({super.key, required this.currentMode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12), // sát header hơn
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20), // bo tròn đầu trên kiểu giọt nước
          bottom: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              context,
              mode: ClassMemberMode.add,
              label: 'Nhập',
              icon: Icons.person_add_alt_1,
              isSelected: currentMode == ClassMemberMode.add,
              isLeft: true,
              isRight: false,
            ),
          ),
          Expanded(
            child: _buildTab(
              context,
              mode: ClassMemberMode.remove,
              label: 'Rút',
              icon: Icons.person_remove_alt_1,
              isSelected: currentMode == ClassMemberMode.remove,
              isLeft: false,
              isRight: false,
            ),
          ),
          Expanded(
            child: _buildTab(
              context,
              mode: ClassMemberMode.transfer,
              label: 'Chuyển',
              icon: Icons.swap_horiz_rounded,
              isSelected: currentMode == ClassMemberMode.transfer,
              isLeft: false,
              isRight: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required ClassMemberMode mode,
    required String label,
    required IconData icon,
    required bool isSelected,
    bool isLeft = false,
    bool isRight = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () => context.read<ClassMemberBloc>().add(ChangeMemberMode(mode)),
      borderRadius: BorderRadius.only(
        topLeft: isLeft ? const Radius.circular(8) : Radius.zero,
        topRight: isRight ? const Radius.circular(8) : Radius.zero,
        bottomLeft: isLeft ? const Radius.circular(20) : Radius.zero,
        bottomRight: isRight ? const Radius.circular(20) : Radius.zero,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? Colors.grey[850] : Colors.grey[100]),
          borderRadius: BorderRadius.only(
            topLeft: isLeft ? const Radius.circular(8) : Radius.zero,
            topRight: isRight ? const Radius.circular(8) : Radius.zero,
            bottomLeft: isLeft ? const Radius.circular(20) : Radius.zero,
            bottomRight: isRight ? const Radius.circular(20) : Radius.zero,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey[400] : Colors.grey[700]),
            ),
            const SizedBox(width: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey[300] : Colors.grey[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
