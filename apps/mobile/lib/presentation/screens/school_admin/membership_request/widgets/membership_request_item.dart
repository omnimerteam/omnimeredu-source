// membership_request_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';
import 'package:flutter_ios_android_platforms/core/app_constants.dart';

class MembershipRequestItem extends StatelessWidget {
  final MembershipRequestEntity request;
  final bool isUpdating;
  final Function(MembershipStatusEnum) onStatusUpdate;

  const MembershipRequestItem({
    super.key,
    required this.request,
    required this.isUpdating,
    required this.onStatusUpdate,
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
        _buildStatusChip(context),
        const Spacer(),
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
            _getStatusText(request.status),
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
      onSelected: (value) => _handleMenuAction(value),
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
          const PopupMenuDivider(),
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
          const PopupMenuDivider(),
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
          const PopupMenuDivider(),
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
    }

    return items;
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'view_detail':
        // TODO: Navigate to detail page
        break;
      case 'approve':
        onStatusUpdate(MembershipStatusEnum.Approved);
        break;
      case 'reject':
        onStatusUpdate(MembershipStatusEnum.Rejected);
        break;
    }
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          context,
          icon: Icons.person_outline_rounded,
          label: 'User ID',
          value: request.userId,
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          context,
          icon: Icons.school_outlined,
          label: 'School ID',
          value: request.schoolId,
        ),
        if (request.classId != null) ...[
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            icon: Icons.class_outlined,
            label: 'Class ID',
            value: request.classId!,
          ),
        ],
        const SizedBox(height: 8),
        _buildInfoRow(
          context,
          icon: Icons.badge_outlined,
          label: 'Vai trò',
          value: _getRoleText(request.role),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          context,
          icon: Icons.assignment_outlined,
          label: 'Hành động',
          value: _getActionText(request.action),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          context,
          icon: Icons.schedule_rounded,
          label: 'Ngày tạo',
          value: AppConstants.dateTimeFormatter.format(request.createdAt),
        ),
        if (request.note != null && request.note!.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            icon: Icons.note_outlined,
            label: 'Ghi chú',
            value: request.note!,
            isMultiline: true,
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment: isMultiline
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusText(MembershipStatusEnum status) {
    switch (status) {
      case MembershipStatusEnum.Pending:
        return 'Chờ duyệt';
      case MembershipStatusEnum.Approved:
        return 'Đã duyệt';
      case MembershipStatusEnum.Rejected:
        return 'Từ chối';
    }
  }

  String _getRoleText(MembershipRoleEnum role) {
    switch (role) {
      case MembershipRoleEnum.Student:
        return 'Học sinh';
      case MembershipRoleEnum.Teacher:
        return 'Giáo viên';
      case MembershipRoleEnum.Staff:
        return 'Nhân viên';
      case MembershipRoleEnum.SchoolAdmin:
        return 'Quản trị viên';
    }
  }

  String _getActionText(MembershipActionEnum action) {
    switch (action) {
      case MembershipActionEnum.Enroll:
        return 'Nhập học/Nhận công tác';
      case MembershipActionEnum.Transfer:
        return 'Chuyển lớp';
      case MembershipActionEnum.Assign:
        return 'Phân công';
      case MembershipActionEnum.Resign:
        return 'Nghỉ học/Thôi công tác';
    }
  }
}
