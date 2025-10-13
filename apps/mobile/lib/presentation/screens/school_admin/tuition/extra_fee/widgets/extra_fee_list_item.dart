import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/tuition/extra_fee_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/dialog/delete_confirm_dialog.dart';
import '../bloc/extra_fee_management_bloc.dart';
import '../bloc/extra_fee_management_event.dart';

class ExtraFeeListItem extends StatelessWidget {
  final ExtraFeeEntity extraFee;

  const ExtraFeeListItem({super.key, required this.extraFee});

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0)} VNĐ';
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
          // Icon + Status
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                child: Center(
                  child: Icon(
                    Icons.attach_money,
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Fee info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Status badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        extraFee.name,
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
                        color: _getStatusColor(
                          extraFee.active,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getStatusLabel(extraFee.active),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getStatusColor(extraFee.active),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Amount
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
                    Expanded(
                      child: Text(
                        _formatCurrency(extraFee.unitAmount),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Description
                if (extraFee.description?.isNotEmpty == true)
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          extraFee.description!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
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

                // Created date
                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      extraFee.createdAt != null
                          ? AppConstants.dateFormatter.format(
                              extraFee.createdAt!,
                            )
                          : 'Không có dữ liệu',
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

          // Action menu
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
                    const Text('Xem chi tiết'),
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
                    const Text('Chỉnh sửa'),
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

  Color _getStatusColor(bool? active) {
    switch (active) {
      case true:
        return Colors.green;
      case false:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(bool? active) {
    switch (active) {
      case true:
        return 'Hoạt động';
      case false:
        return 'Không hoạt động';
      default:
        return 'Không rõ';
    }
  }

  void _handleMenuAction(BuildContext context, String action) {
    final bloc = context.read<ExtraFeeManagementBloc>();
    switch (action) {
      case 'view_details':
        bloc.add(ShowExtraFeeDetailsEvent(extraFee));
        break;
      case 'edit':
        // TODO: Show edit dialog
        break;
      case 'delete':
        _showConfirmDelete(context);
        break;
    }
  }

  void _showConfirmDelete(BuildContext context) {
    final bloc = context.read<ExtraFeeManagementBloc>();
    showDialog(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        title: 'Xóa phí phụ',
        message:
            'Bạn có chắc chắn muốn xóa phí phụ "${extraFee.name}"?\nHành động này không thể hoàn tác.',
        onConfirm: () {
          bloc.add(DeleteExtraFeeEvent(extraFee.id!));
        },
      ),
    );
  }
}
