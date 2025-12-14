import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';

/// Widget hiển thị timer đếm ngược
class QRTimerWidget extends StatelessWidget {
  final int remainingSeconds;
  final bool isExpired;

  const QRTimerWidget({
    Key? key,
    required this.remainingSeconds,
    this.isExpired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    Color timerColor;
    IconData timerIcon;
    String timerText;

    if (isExpired) {
      timerColor = AppColors.error;
      timerIcon = Icons.error_outline;
      timerText = 'Mã đã hết hạn';
    } else if (remainingSeconds < 60) {
      timerColor = AppColors.error;
      timerIcon = Icons.timer;
      timerText = 'Hết hạn sau: $timeString';
    } else if (remainingSeconds < 180) {
      timerColor = AppColors.warning;
      timerIcon = Icons.timer;
      timerText = 'Hết hạn sau: $timeString';
    } else {
      timerColor = AppColors.success;
      timerIcon = Icons.timer;
      timerText = 'Hết hạn sau: $timeString';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: timerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: timerColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(timerIcon, color: timerColor, size: 20),
          const SizedBox(width: 8),
          Text(
            timerText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: timerColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

