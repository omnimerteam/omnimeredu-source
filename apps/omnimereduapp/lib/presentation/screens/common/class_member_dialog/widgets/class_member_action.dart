import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../bloc/class_member_bloc.dart';
import '../bloc/class_member_event.dart';

class ClassMemberActions extends StatelessWidget {
  final bool canSubmit;
  final bool isSubmitting;
  final ClassMemberMode mode;

  const ClassMemberActions({
    super.key,
    required this.canSubmit,
    required this.isSubmitting,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Nút Đóng
        Expanded(
          child: OutlinedButton(
            onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Đóng'),
          ),
        ),

        const SizedBox(width: 12),

        // Nút chính (Nhập lớp / Rút lớp / Chuyển lớp)
        Expanded(
          child: ElevatedButton(
            onPressed: canSubmit && !isSubmitting
                ? () {
                    context.read<ClassMemberBloc>().add(
                      const SubmitClassMember(),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: _getButtonColor(mode),
            ),
            child: isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getButtonIcon(mode), size: 20),
                      const SizedBox(width: 8),
                      Text(_getButtonText(mode)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Color _getButtonColor(ClassMemberMode mode) {
    switch (mode) {
      case ClassMemberMode.add:
        return AppColors.success;
      case ClassMemberMode.remove:
        return AppColors.red;
      case ClassMemberMode.transfer:
        return AppColors.primary;
    }
  }

  IconData _getButtonIcon(ClassMemberMode mode) {
    switch (mode) {
      case ClassMemberMode.add:
        return Icons.person_add;
      case ClassMemberMode.remove:
        return Icons.person_remove;
      case ClassMemberMode.transfer:
        return Icons.swap_horiz;
    }
  }

  String _getButtonText(ClassMemberMode mode) {
    switch (mode) {
      case ClassMemberMode.add:
        return 'Nhập lớp';
      case ClassMemberMode.remove:
        return 'Rút lớp';
      case ClassMemberMode.transfer:
        return 'Chuyển lớp';
    }
  }
}
