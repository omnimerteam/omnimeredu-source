import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/dashboard/school_admin/school_admin_dashboard_data_entity.dart';
import 'widgets/dashboard_quick_overview_skeleton.dart';
import '../../../widgets/chart/attendance_chart.dart';
import '../../../widgets/skeleton/common_skeleton.dart';
import 'widgets/dashboard_quick_overview.dart';
import 'widgets/school_admin_dashboard_quick_access.dart';

class SchoolAdminDashboard extends StatelessWidget {
  final SchoolAdminDashboardDataEntity? data;
  final bool isLoading;
  final String roleName;

  const SchoolAdminDashboard({
    Key? key,
    this.data,
    this.isLoading = false,
    required this.roleName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Nếu loading
    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardQuickOverviewSkeleton(),
          SizedBox(height: 24),
          SkeletonBox(height: 200),
          SizedBox(height: 24),
          SchoolAdminDashboardQuickAccess(),
          SizedBox(height: 24),
          SkeletonBox(height: 120),
        ],
      );
    }

    // Nếu load xong mà chưa có dữ liệu => hiển thị hướng dẫn
    if (!isLoading && data == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[850]
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.school,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.lightBlue
                          : AppColors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Chưa có trường nào được tạo',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: Text(
                    'Vui lòng tạo trường đầu tiên để bắt đầu quản lý.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textLight.withOpacity(0.8)
                          : AppColors.textDark.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SchoolAdminDashboardQuickAccess(highlightSchool: true),
        ],
      );
    }

    // Nếu có dữ liệu => hiển thị dashboard bình thường
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardQuickOverview(overview: data!.overview),
        const SizedBox(height: 24),
        AttendanceChart(classStats: data!.attendanceStats.classAttendanceRates),
        const SizedBox(height: 24),
        SchoolAdminDashboardQuickAccess(),
      ],
    );
  }
}
