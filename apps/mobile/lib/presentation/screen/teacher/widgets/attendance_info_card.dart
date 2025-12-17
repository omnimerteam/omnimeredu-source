import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class AttendanceInfoCard extends StatelessWidget {
  final String className;
  final String? subject;
  final DateTime date;

  const AttendanceInfoCard({
    Key? key,
    required this.className,
    this.subject,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildRow('Lớp', className),
            if (subject != null) ...[
              SizedBox(height: 8.h),
              _buildRow('Môn học', subject!),
            ],
            SizedBox(height: 8.h),
            _buildRow('Ngày', '${date.day}/${date.month}/${date.year}'),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.grey600, fontSize: 14.sp),
        ),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
      ],
    );
  }
}
