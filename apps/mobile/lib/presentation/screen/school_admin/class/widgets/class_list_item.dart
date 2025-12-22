import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/entities/class/class_entity.dart';
import '../../../../common/blocs/auth_bloc/auth_bloc.dart';
import '../../../../common/widgets/dialog/delete_confirm_dialog.dart';
import '../../../../common/widgets/snackbar/app_snack_bar.dart';
import '../bloc/class_management_bloc.dart';
import '../bloc/class_management_event.dart';

class ClassListItem extends StatelessWidget {
  final ClassEntity classDetail;

  const ClassListItem({super.key, required this.classDetail});

  @override
  Widget build(BuildContext context) {
    // Note: Assuming AuthBloc state is AuthenticationAuthenticated for school admin/teacher
    // Adjust logic if user structure is different in Mobile's AuthBloc
    final authState = context.watch<AuthBloc>().state;

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
          // ==== Class Info ====
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        classDetail.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (classDetail.code != null)
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
                          classDetail.code!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
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
                      'Học sinh: ${classDetail.currentStudents}/${classDetail.maxStudents ?? "∞"}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Học phí: ${classDetail.baseFee}',
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

          // ==== Action Menu ====
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

              // Simplification: Always show for now, logic can be refined
              items.addAll([
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
                  value: 'details_class',
                  child: Row(
                    children: [
                      Icon(
                        Icons.info,
                        size: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 12),
                      const Text('Chi tiết'),
                    ],
                  ),
                ),
              ]);

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
    AuthState authState, // Assuming AuthBloc state type
  ) {
    final bloc = context.read<ClassManagementBloc>();

    switch (action) {
      case 'update':
        bloc.add(LoadClassForEditEvent(classDetail));
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
      case 'details_class':
        // Navigation to details
        AppSnackBars.showWarning(context, 'Tính năng đang phát triển');
        break;
      default:
        AppSnackBars.showWarning(context, 'Tính năng đang phát triển');
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        title: 'Xóa lớp học?',
        message: // Note: DeleteConfirmationDialog params might differ, check signature
            'Bạn có chắc chắn muốn xóa lớp "${classDetail.name}"?\nHành động này không thể hoàn tác.',
        onConfirm: () {
          context.read<ClassManagementBloc>().add(
            DeleteClassEvent(
              classDetail.id,
            ), // id is non-nullable in mobile ClassEntity
          );
        },
      ),
    );
  }
}
