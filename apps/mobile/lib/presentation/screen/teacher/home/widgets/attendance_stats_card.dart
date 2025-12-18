import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../bloc/teacher_attendance_state.dart';

class AttendanceStatsCard extends StatelessWidget {
  final AttendanceStats stats;

  const AttendanceStatsCard({Key? key, required this.stats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                context,
                'Có mặt',
                stats.present,
                AppColors.success,
              ),
            ),
            _buildDivider(),
            Expanded(
              child: _buildStatItem(
                context,
                'Vắng',
                stats.absent,
                AppColors.red,
              ),
            ),
            _buildDivider(),
            Expanded(
              child: _buildStatItem(context, 'Muộn', stats.late, Colors.orange),
            ),
            _buildDivider(),
            Expanded(
              child: _buildStatItem(
                context,
                'Phép',
                stats.leave,
                AppColors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    int value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: AppColors.grey600),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 30.h, width: 1.w, color: AppColors.grey300);
  }
}
