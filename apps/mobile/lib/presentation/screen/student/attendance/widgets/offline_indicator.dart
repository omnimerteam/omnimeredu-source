import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

/// Widget hiển thị trạng thái offline và pending scans
class OfflineIndicatorWidget extends StatelessWidget {
  final bool isOnline;
  final int pendingScans;

  const OfflineIndicatorWidget({
    Key? key,
    required this.isOnline,
    this.pendingScans = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isOnline && pendingScans == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isOnline ? AppColors.info : AppColors.warning,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.sync : Icons.wifi_off,
            color: AppColors.textLight,
            size: 20,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              isOnline
                  ? 'Đang đồng bộ $pendingScans điểm danh offline...'
                  : 'Chế độ offline - Dữ liệu sẽ tự động đồng bộ khi có mạng',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textLight,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
