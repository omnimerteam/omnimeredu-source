import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/display_mapper.dart';
import 'package:intl/intl.dart';
import '../../../../../domain/entities/user/student_entity.dart';
import '../../../../widgets/dialog/delete_confirm_dialog.dart';
import '../bloc/student_management_bloc.dart';
import '../bloc/student_management_event.dart';

class StudentListItem extends StatelessWidget {
  final StudentEntity student;

  const StudentListItem({super.key, required this.student});

  String _formatBirthday(DateTime? birthday) {
    if (birthday == null) return 'Chưa có thông tin';
    return DateFormat('dd/MM/yyyy').format(birthday);
  }

  String _calculateAge(DateTime? birthday) {
    if (birthday == null) return '';
    final now = DateTime.now();
    final age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
      return '(${age - 1} tuổi)';
    }
    return '($age tuổi)';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                student.fullName.isNotEmpty == true
                    ? student.fullName.substring(0, 1).toUpperCase()
                    : '?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Student Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Gender
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        student.fullName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (student.gender != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: student.gender == 'Female'
                              ? Colors.pink.withOpacity(0.1)
                              : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          DisplayMapper.genderName(student.gender),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: student.gender == 'Female'
                                    ? Colors.pink
                                    : Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),

                // Birthday and Age
                Row(
                  children: [
                    Icon(
                      Icons.cake_outlined,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_formatBirthday(student.birthday)} ${_calculateAge(student.birthday)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Grade and Class
                Row(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Khối học: ${student.gradeGroup?.displayName ?? 'N/A'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Phone number (if available)
                if (student.phone?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        student.phone!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Action Menu
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'view_details',
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    const Text('Chi tiết học sinh'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 12),
                    const Text('Cập nhật thông tin'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    const Text('Xóa học sinh'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    final bloc = context.read<StudentManagementBloc>();

    switch (action) {
      case 'view_details':
        if (student.id != null) {
          bloc.add(LoadStudentByIdEvent(student.id!));
        }
        break;
      case 'edit':
        if (student.id != null) {
          bloc.add(LoadStudentForEditEvent(student));
        }
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        message:
            'Bạn có chắc chắn muốn xóa học sinh "${student.fullName}"?\nHành động này không thể hoàn tác.',
        onConfirm: () {
          if (student.id != null) {
            context.read<StudentManagementBloc>().add(
              DeleteStudentEvent(student.id!),
            );
          }
        },
      ),
    );
  }
}
