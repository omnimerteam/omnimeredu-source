import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/school/membership_request_entity.dart';
import '../../../../../core/utils/display_mapper.dart';
import 'membership_request_detail_sheet.dart';

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
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: () => _showDetailDialog(context),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: 12.h),
                _buildContent(context),
              ],
            ),
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
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.badge_outlined,
                size: 18.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 8.w),
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

        SizedBox(width: 12.w),

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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14.sp, color: statusColor),
          SizedBox(width: 4.w),
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
        width: 20.w,
        height: 20.w,
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
        size: 24.sp,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
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
              size: 18.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 12.w),
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
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 18.sp,
                  color: Colors.green,
                ),
                SizedBox(width: 12.w),
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
                Icon(Icons.cancel_outlined, size: 18.sp, color: Colors.red),
                SizedBox(width: 12.w),
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
                Icon(Icons.cancel_outlined, size: 18.sp, color: Colors.red),
                SizedBox(width: 12.w),
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
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 18.sp,
                  color: Colors.green,
                ),
                SizedBox(width: 12.w),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
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
          _buildInfoRow(
            context,
            Icons.person_outline_rounded,
            'Họ tên',
            request.fullName!,
          ),
          SizedBox(height: 8.h),
        ],

        _buildInfoRow(
          context,
          Icons.assignment_outlined,
          'Hành động',
          DisplayMapper.membershipActionName(request.action.name),
        ),

        // Removed date here as it might be too much info for the card
      ],
    );
  }

  // Local simple row helper if InfoRowWidget isn't imported
  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Theme.of(context).colorScheme.outline),
        SizedBox(width: 8.w),
        Text('$label: ', style: Theme.of(context).textTheme.bodySmall),
        Expanded(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
