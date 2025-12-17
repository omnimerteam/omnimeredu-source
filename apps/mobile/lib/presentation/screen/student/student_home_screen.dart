import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/routing/route_config.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context),
            SizedBox(height: 24.h),
            Text(
              'Chức năng nhanh',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildActionButtons(context),
            SizedBox(height: 24.h),
            Text(
              'Lịch học hôm nay',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Expanded(child: _buildTodaySchedule(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xin chào, Sinh viên!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Chúc bạn một ngày học tập hiệu quả.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            icon: Icons.qr_code_scanner,
            label: 'Quét QR',
            color: Colors.orange,
            onTap: () {
              Navigator.pushNamed(context, RouteConfig.studentScanQr);
            },
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildActionButton(
            context,
            icon: Icons.history,
            label: 'Lịch sử',
            color: Colors.green,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tính năng đang phát triển')),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32.w, color: color),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaySchedule(BuildContext context) {
    // Placeholder schedule
    return ListView(
      children: [
        _buildScheduleItem(
          context,
          time: '07:00 - 09:00',
          subject: 'Lập trình di động',
          room: 'P.302',
          status: 'Đã điểm danh',
          statusColor: AppColors.success,
        ),
        SizedBox(height: 12.h),
        _buildScheduleItem(
          context,
          time: '09:30 - 11:30',
          subject: 'Cấu trúc dữ liệu',
          room: 'P.405',
          status: 'Chưa điểm danh',
          statusColor: AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildScheduleItem(
    BuildContext context, {
    required String time,
    required String subject,
    required String room,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14.sp,
                      color: AppColors.grey600,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      time,
                      style: TextStyle(
                        color: AppColors.grey600,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Icons.room, size: 14.sp, color: AppColors.grey600),
                    SizedBox(width: 4.w),
                    Text(
                      room,
                      style: TextStyle(
                        color: AppColors.grey600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
