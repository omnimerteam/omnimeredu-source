import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class QRTimerWidget extends StatelessWidget {
  final int remainingSeconds;
  final bool isExpired;

  const QRTimerWidget({
    Key? key,
    required this.remainingSeconds,
    required this.isExpired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minutes = (remainingSeconds / 60).floor();
    final seconds = remainingSeconds % 60;
    final timeStr =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Column(
      children: [
        Text(
          isExpired ? 'Hết hạn' : timeStr,
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: isExpired ? AppColors.red : AppColors.primary,
          ),
        ),
        if (!isExpired)
          Text(
            'Mã sẽ hết hạn trong',
            style: TextStyle(fontSize: 14.sp, color: AppColors.grey600),
          ),
      ],
    );
  }
}
