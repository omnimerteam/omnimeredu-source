// membership_request_item.dart
import 'package:flutter/material.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/membership_request/membership_request_entity.dart';
import '../../../../../core/constants/app_constant.dart';
import 'membership_request_detail_sheet.dart';
import '../../../../utils/display_mapper.dart';

import '../../../../widgets/text/info_row_widget.dart';

class MembershipRequestItem extends StatelessWidget {
  final MembershipRequestEntity request;
  final bool isUpdating;
  final Function(MembershipStatusEnum) onStatusUpdate;
  final VoidCallback? onViewDetail;

  const MembershipRequestItem({
    super.key,
    required this.request,
    required this.isUpdating,
    required this.onStatusUpdate,
    this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 12),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Vai trò -> to và nổi bật hơn
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.badge_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                DisplayMapper.roleName(request.role.name),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Trạng thái
        _buildStatusChip(context),

        const SizedBox(width: 12),

        // Nút hành động
        _buildActionButton(context),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (request.status) {
      case MembershipStatusEnum.Pending:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule_rounded;
        break;
      case MembershipStatusEnum.Approved:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        break;
      case MembershipStatusEnum.Rejected:
        statusColor = Colors.red;
        statusIcon = Icons.cancel_rounded;
        break;
      case MembershipStatusEnum.None:
        statusColor = Colors.grey;
        statusIcon = Icons.blur_circular;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14, color: statusColor),
          const SizedBox(width: 4),
          Text(
            DisplayMapper.membershipStatusName(request.status.name),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    if (isUpdating) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => _buildMenuItems(context),
      onSelected: (value) => _handleMenuAction(value, context),
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(BuildContext context) {
    final items = <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'view_detail',
        child: Row(
          children: [
            Icon(
              Icons.visibility_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text('Xem chi tiết', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    ];

    // Add status update options based on current status
    switch (request.status) {
      case MembershipStatusEnum.Pending:
        items.addAll([
          PopupMenuItem<String>(
            value: 'approve',
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 18,
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                Text(
                  'Phê duyệt',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.green),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'reject',
            child: Row(
              children: [
                const Icon(Icons.cancel_outlined, size: 18, color: Colors.red),
                const SizedBox(width: 12),
                Text(
                  'Từ chối',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
              ],
            ),
          ),
        ]);
        break;
      case MembershipStatusEnum.Approved:
        items.addAll([
          PopupMenuItem<String>(
            value: 'reject',
            child: Row(
              children: [
                const Icon(Icons.cancel_outlined, size: 18, color: Colors.red),
                const SizedBox(width: 12),
                Text(
                  'Từ chối',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
              ],
            ),
          ),
        ]);
        break;
      case MembershipStatusEnum.Rejected:
        items.addAll([
          PopupMenuItem<String>(
            value: 'approve',
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 18,
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                Text(
                  'Phê duyệt',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.green),
                ),
              ],
            ),
          ),
        ]);
        break;
      case MembershipStatusEnum.None:
        break;
    }

    return items;
  }

  void _handleMenuAction(String value, BuildContext context) {
    switch (value) {
      case 'view_detail':
        _showDetailDialog(context); // 👈 mở bottom sheet trực tiếp
        break;
      case 'approve':
        onStatusUpdate(MembershipStatusEnum.Approved);
        break;
      case 'reject':
        onStatusUpdate(MembershipStatusEnum.Rejected);
        break;
    }
  }

  void _showDetailDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white, // tránh bị trong suốt
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => MembershipRequestDetailSheet(
        request: request,
        onStatusUpdate: onStatusUpdate,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chỉ hiển thị thông tin quan trọng nhất
        if (request.fullName != null) ...[
          InfoRowWidget(
            icon: Icons.person_outline_rounded,
            label: 'Họ tên',
            value: request.fullName!,
          ),
          const SizedBox(height: 8),
        ],

        InfoRowWidget(
          icon: Icons.assignment_outlined,
          label: 'Hành động',
          value: DisplayMapper.membershipActionName(request.action.name),
        ),

        if (request.createdAt != null) ...[
          const SizedBox(height: 8),
          InfoRowWidget(
            icon: Icons.schedule_rounded,
            label: 'Ngày tạo',
            value: AppConstants.dateTimeFormatter.format(request.createdAt!),
          ),
        ],
      ],
    );
  }
}
