import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/bloc/authentication/authentication_bloc.dart';
import '../../../../../core/bloc/authentication/authentication_state.dart';
import '../../../../../core/constants/app_constant.dart';
import '../../../../../domain/entities/class/class_entity.dart';
import '../../../common/class_member_dialog/bloc/class_member_event.dart';
import '../../../common/class_member_dialog/class_member_dialog_helper.dart';
import '../../../../widgets/common/app_snack_bar.dart';
import '../../../../widgets/dialog/delete_confirm_dialog.dart';
import '../bloc/class_management_bloc.dart';
import '../bloc/class_management_event.dart';

class ClassListItem extends StatelessWidget {
  final ClassEntity classDetail;

  const ClassListItem({super.key, required this.classDetail});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;

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
          // ==== Thông tin lớp ====
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        classDetail.name ?? 'Không có tên',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        classDetail.code ?? 'N/A',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.group,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Học sinh: ${classDetail.students?.length ?? 0}/${classDetail.maxStudents ?? "0"}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.money,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Tiền học: ${AppConstants.currencyFormatter.format(classDetail.baseFee ?? 0)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // ==== Menu hành động ====
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value, authState),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            itemBuilder: (context) {
              final items = <PopupMenuEntry<String>>[];

              if (authState is AuthenticationAuthenticated &&
                  authState.user.roleName == 'SchoolAdmin') {
                items.addAll([
                  PopupMenuItem(
                    value: 'details_class',
                    child: Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 18,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 12),
                        const Text('Chi tiết lớp học'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'update',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        const Text('Cập nhật'),
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
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 12),
                        const Text('Xóa'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'add_student',
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_add,
                          size: 18,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 12),
                        const Text('Thêm học sinh'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'assign_teacher',
                    child: Row(
                      children: [
                        Icon(
                          Icons.assignment_ind,
                          size: 18,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 12),
                        const Text('Phân bổ giáo viên'),
                      ],
                    ),
                  ),
                ]);
              } else if (authState is AuthenticationAuthenticated &&
                  authState.user.roleName == 'Teacher') {
                items.addAll([
                  PopupMenuItem(
                    value: 'details_class',
                    child: Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 18,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 12),
                        const Text('Chi tiết lớp học'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'add_student',
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_add,
                          size: 18,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 12),
                        const Text('Thêm học sinh'),
                      ],
                    ),
                  ),
                ]);
              }

              return items;
            },
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    String action,
    AuthenticationState authState,
  ) {
    final bloc = context.read<ClassManagementBloc>();

    switch (action) {
      case 'update':
        if (classDetail.id != null) {
          bloc.add(LoadClassForEditEvent(classDetail));
        }
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
      case 'add_student':
        if (authState is! AuthenticationAuthenticated) return;

        final user = authState.user;

        showClassMemberDialog(
          context: context,
          schoolId: user.schoolId ?? '',
          teacherId: user.roleName == 'Teacher' ? user.id : null,
          initialClassId: classDetail.id,
          initialMode: ClassMemberMode.add,
          isTeacher: user.roleName == 'Teacher',
        ).then((result) {
          if (result == true) {
            // Refresh danh sách lớp
            context.read<ClassManagementBloc>().add(LoadClassesEvent());
          }
        });
        break;

      case 'assign_teacher':
        AppSnackBars.showComingSoon(context, 'Đăng ký giảng dạy');
        break;
      case 'details_class':
        Navigator.pushNamed(
          context,
          '/school-admin/classes/detail',
          arguments: {'classId': classDetail.id},
        );
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        message:
            'Bạn có chắc chắn muốn xóa lớp "${classDetail.name}"?\nHành động này không thể hoàn tác.',
        onConfirm: () {
          if (classDetail.id != null) {
            context.read<ClassManagementBloc>().add(
              DeleteClassEvent(classDetail.id!),
            );
          }
        },
      ),
    );
  }
}
