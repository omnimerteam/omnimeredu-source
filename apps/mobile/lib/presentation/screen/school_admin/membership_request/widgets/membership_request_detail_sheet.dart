import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/school/membership_request_entity.dart';
import '../../../../../core/constants/app_constant.dart';
import '../../../../../core/utils/display_mapper.dart';
import '../../../../common/widgets/button/app_button.dart';
import 'info_row_widget.dart';

class MembershipRequestDetailSheet extends StatelessWidget {
  final MembershipRequestEntity request;
  final Function(MembershipStatusEnum) onStatusUpdate;

  const MembershipRequestDetailSheet({
    super.key,
    required this.request,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        // Để tránh bị che bởi bàn phím
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 🔑 co vừa nội dung
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildStatusCard(context),
                  SizedBox(height: 16.h),
                  _buildInfoCard(context),
                ],
              ),
            ),
            _buildActionBar(context),
          ],
        ),
      ),
    );
  }

  /// 🔹 Thẻ trạng thái
  Widget _buildStatusCard(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (request.status) {
      case MembershipStatusEnum.Pending:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule_rounded;
        statusText = 'Đang chờ xử lý';
        break;
      case MembershipStatusEnum.Approved:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        statusText = 'Đã phê duyệt';
        break;
      case MembershipStatusEnum.Rejected:
        statusColor = Colors.red;
        statusIcon = Icons.cancel_rounded;
        statusText = 'Đã từ chối';
        break;
      case MembershipStatusEnum.None:
        statusColor = Colors.grey;
        statusIcon = Icons.blur_circular;
        statusText = 'Chưa được xử lý';
        break;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            colors: [
              statusColor.withOpacity(0.1),
              statusColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Icon(statusIcon, size: 48.sp, color: statusColor),
            SizedBox(height: 12.h),
            Text(
              statusText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Thẻ thông tin
  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin chi tiết',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),

            if (request.fullName != null) ...[
              InfoRowWidget(
                icon: Icons.person_outline_rounded,
                label: 'Họ và tên',
                value: request.fullName!,
              ),
              SizedBox(height: 12.h),
            ],

            InfoRowWidget(
              icon: Icons.badge_outlined,
              label: 'Vai trò',
              value: DisplayMapper.roleName(request.role.name),
            ),
            SizedBox(height: 12.h),

            InfoRowWidget(
              icon: Icons.assignment_outlined,
              label: 'Hành động',
              value: DisplayMapper.membershipActionName(request.action.name),
            ),

            if (request.classId != null &&
                request.className != null &&
                request.classCode != null) ...[
              SizedBox(height: 12.h),
              InfoRowWidget(
                icon: Icons.class_outlined,
                label: 'Lớp học',
                value: "${request.className!} - ${request.classCode!}",
              ),
            ],

            if (request.createdAt != null) ...[
              SizedBox(height: 12.h),
              InfoRowWidget(
                icon: Icons.schedule_rounded,
                label: 'Ngày tạo',
                value: AppConstants.dateTimeFormatter.format(
                  request.createdAt!,
                ),
              ),
            ],

            if (request.note != null && request.note!.isNotEmpty) ...[
              SizedBox(height: 16.h),
              const Divider(),
              SizedBox(height: 16.h),
              Text(
                'Ghi chú',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  request.note!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 🔹 Thanh nút hành động
  Widget _buildActionBar(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h + bottomPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          // 🔹 Nút Đóng
          Expanded(
            child: AppButton(
              type: AppButtonType.secondary,
              text: "Đóng",
              onPressed: () => Navigator.pop(context),
            ),
          ),
          if (request.status != MembershipStatusEnum.Approved) ...[
            SizedBox(width: 12.w),
            Expanded(
              child: AppButton(
                text: "Phê duyệt",
                type: AppButtonType.success,
                onPressed: () {
                  onStatusUpdate(MembershipStatusEnum.Approved);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
          if (request.status != MembershipStatusEnum.Rejected) ...[
            SizedBox(width: 12.w),
            Expanded(
              child: AppButton(
                text: "Từ chối",
                type: AppButtonType.danger,
                onPressed: () {
                  onStatusUpdate(MembershipStatusEnum.Rejected);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
