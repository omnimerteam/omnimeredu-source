import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';
import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/presentation/utils/display_mapper.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/app_button.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/text/info_row_widget.dart';

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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildStatusCard(context),
                  const SizedBox(height: 16),
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
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
            Icon(statusIcon, size: 48, color: statusColor),
            const SizedBox(height: 12),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin chi tiết',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            if (request.fullName != null) ...[
              InfoRowWidget(
                icon: Icons.person_outline_rounded,
                label: 'Họ và tên',
                value: request.fullName!,
              ),
              const SizedBox(height: 12),
            ],

            InfoRowWidget(
              icon: Icons.badge_outlined,
              label: 'Vai trò',
              value: DisplayMapper.roleName(request.role.name),
            ),
            const SizedBox(height: 12),

            InfoRowWidget(
              icon: Icons.assignment_outlined,
              label: 'Hành động',
              value: DisplayMapper.membershipActionName(request.action.name),
            ),

            if (request.classId != null &&
                request.className != null &&
                request.classCode != null) ...[
              const SizedBox(height: 12),
              InfoRowWidget(
                icon: Icons.class_outlined,
                label: 'Lớp học',
                value: "${request.className!} - ${request.classCode!}",
              ),
            ],

            if (request.createdAt != null) ...[
              const SizedBox(height: 12),
              InfoRowWidget(
                icon: Icons.schedule_rounded,
                label: 'Ngày tạo',
                value: AppConstants.dateTimeFormatter.format(
                  request.createdAt!,
                ),
              ),
            ],

            if (request.note != null && request.note!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Ghi chú',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
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
      padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottomPadding),
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
            const SizedBox(width: 12),
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
            const SizedBox(width: 12),
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
