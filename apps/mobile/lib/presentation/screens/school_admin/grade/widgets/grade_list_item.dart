import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/display_mapper.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/common/app_snack_bar.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/dialog/delete_confirm_dialog.dart';

class GradeListItem extends StatelessWidget {
  final GradeEntity grade;
  final Function(GradeEntity) onEdit;
  final Function(String) onDelete;
  final Function(GradeEntity) onViewDetails;

  const GradeListItem({
    super.key,
    required this.grade,
    required this.onEdit,
    required this.onDelete,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Bên trái: thông tin grade
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên grade + trạng thái
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${grade.order}. ${grade.name}",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildActiveStatus(theme),
                  ],
                ),
                const SizedBox(height: 4),

                // Cấp học
                Row(
                  children: [
                    Icon(
                      Icons.school,
                      size: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DisplayMapper.educationLevelName(grade.level.name),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Độ tuổi
                if (grade.ageRange != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.cake,
                        size: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Độ tuổi: ${grade.ageRange!['min']}-${grade.ageRange!['max']}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],

                // Mô tả
                if (grade.description != null &&
                    grade.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    grade.description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Menu hành động
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            icon: Icon(
              Icons.settings,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    const Text('Xem chi tiết'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: 18,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 12),
                    const Text('Chỉnh sửa'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      size: 18,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    const Text('Xóa'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveStatus(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: grade.active
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        grade.active ? 'Hoạt động' : 'Tạm dừng',
        style: theme.textTheme.bodySmall?.copyWith(
          color: grade.active
              ? theme.colorScheme.primary
              : theme.colorScheme.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'view':
        onViewDetails(grade);
        break;
      case 'edit':
        onEdit(grade);
        break;
      case 'delete':
        showDialog(
          context: context,
          builder: (_) => DeleteConfirmationDialog(
            message:
                'Bạn có chắc chắn muốn xóa khối "${grade.name}"?\nHành động này không thể hoàn tác.',
            onConfirm: () => onDelete(grade.id!),
          ),
        );
        break;
      default:
        AppSnackBars.showComingSoon(context, action);
    }
  }
}
