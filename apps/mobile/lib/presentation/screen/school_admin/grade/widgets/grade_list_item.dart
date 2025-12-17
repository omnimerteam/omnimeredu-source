import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/domain/entities/grade/grade_entity.dart';
import 'package:mobile/presentation/common/widgets/dialog/delete_confirm_dialog.dart';
import 'package:mobile/presentation/common/widgets/snackbar/app_snack_bar.dart';

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
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
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
                    SizedBox(width: 8.w),
                    _buildActiveStatus(theme),
                  ],
                ),
                SizedBox(height: 4.h),

                // Cấp học
                Row(
                  children: [
                    Icon(
                      Icons.school,
                      size: 16.sp,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      grade.level.displayName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                // Độ tuổi
                if (grade.ageRange != null) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.cake,
                        size: 16.sp,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      SizedBox(width: 6.w),
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
                  SizedBox(height: 4.h),
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

          SizedBox(width: 12.w),

          // Menu hành động
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            icon: Icon(
              Icons.settings,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              size: 24.sp,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      size: 18.sp,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 12.w),
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
                      size: 18.sp,
                      color: theme.colorScheme.secondary,
                    ),
                    SizedBox(width: 12.w),
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
                      size: 18.sp,
                      color: theme.colorScheme.error,
                    ),
                    SizedBox(width: 12.w),
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: grade.active
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
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
