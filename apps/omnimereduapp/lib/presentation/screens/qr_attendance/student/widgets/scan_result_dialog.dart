import 'package:flutter/material.dart';
import '../../../../../domain/entities/qr_attendance/scan_result_entity.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/qr_theme.dart';

/// Dialog hiển thị kết quả quét QR
class ScanResultDialog extends StatelessWidget {
  final ScanResultEntity result;
  final VoidCallback onClose;

  const ScanResultDialog({
    Key? key,
    required this.result,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getStatusIcon(),
                size: 48,
                color: _getStatusColor(),
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              _getTitle(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: _getStatusColor(),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              result.message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            // Additional info
            if (result.distance != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Khoảng cách: ${result.distance!.toStringAsFixed(0)}m',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
            if (result.attendanceTime != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(result.attendanceTime!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getStatusColor(),
                  foregroundColor: AppColors.textLight,
                ),
                child: const Text('Đóng'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (result.status) {
      case ScanStatus.success:
        return AppColors.success;
      case ScanStatus.offline:
        return AppColors.info;
      case ScanStatus.expired:
      case ScanStatus.invalidQR:
      case ScanStatus.alreadyScanned:
        return AppColors.warning;
      case ScanStatus.outOfRange:
      case ScanStatus.error:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon() {
    switch (result.status) {
      case ScanStatus.success:
        return Icons.check_circle;
      case ScanStatus.offline:
        return Icons.cloud_off;
      case ScanStatus.expired:
        return Icons.timer_off;
      case ScanStatus.outOfRange:
        return Icons.location_off;
      case ScanStatus.invalidQR:
        return Icons.qr_code_2;
      case ScanStatus.alreadyScanned:
        return Icons.done_all;
      case ScanStatus.error:
        return Icons.error;
    }
  }

  String _getTitle() {
    switch (result.status) {
      case ScanStatus.success:
        return 'Điểm danh thành công!';
      case ScanStatus.offline:
        return 'Đã lưu offline';
      case ScanStatus.expired:
        return 'Mã đã hết hạn';
      case ScanStatus.outOfRange:
        return 'Vị trí không hợp lệ';
      case ScanStatus.invalidQR:
        return 'Mã QR không hợp lệ';
      case ScanStatus.alreadyScanned:
        return 'Đã điểm danh';
      case ScanStatus.error:
        return 'Có lỗi xảy ra';
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')} - '
        '${time.day}/${time.month}/${time.year}';
  }
}

