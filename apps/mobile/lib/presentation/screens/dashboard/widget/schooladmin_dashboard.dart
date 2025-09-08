import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/core/theme/app_colors.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/dashboard_overview_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/school_admin_dashboard_data_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/button/quick_access_button.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/card/stat_card.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/chart/attendance_chart.dart';

class SchoolAdminDashboard extends StatelessWidget {
  final SchoolAdminDashboardDataEntity data;

  const SchoolAdminDashboard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuickOverview(data.overview, context),
        const SizedBox(height: 24),

        // Attendance
        AttendanceChart(
          classAttendanceRates: data.attendanceStats.classAttendanceRates,
        ),
        const SizedBox(height: 24),

        // Quick Access
        _buildQuickAccess(context),
        const SizedBox(height: 24),

        // Analytics Preview
        _buildAnalyticsPreview(context),
      ],
    );
  }

  Widget _buildQuickOverview(
    DashboardOverviewEntity overview,
    BuildContext context,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng quan hệ thống',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Học sinh',
                    value: overview.totalStudents.toString(),
                    icon: Icons.people,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Giáo viên',
                    value: overview.totalTeachers.toString(),
                    icon: Icons.person,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Lớp học',
                    value: overview.totalClasses.toString(),
                    icon: Icons.class_,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Yêu cầu tham gia',
                    value: overview.membershipRequests.toString(),
                    icon: Icons.person_add,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccess(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Truy cập nhanh',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            QuickAccessButton(
              title: 'Quản lý Lớp',
              icon: Icons.class_,
              color: Colors.orange,
              onTap: () {},
            ),
            QuickAccessButton(
              title: 'Quản lý Học sinh',
              icon: Icons.people,
              color: Colors.blue,
              onTap: () {},
            ),
            QuickAccessButton(
              title: 'Quản lý Giáo viên',
              icon: Icons.person,
              color: Colors.green,
              onTap: () {},
            ),
            QuickAccessButton(
              title: 'Điểm danh',
              icon: Icons.fact_check,
              color: Colors.teal,
              onTap: () {},
            ),
            QuickAccessButton(
              title: 'Học phí',
              icon: Icons.payment,
              color: Colors.red,
              badge: '12',
              onTap: () {},
            ),
            QuickAccessButton(
              title: 'Bài viết',
              icon: Icons.article,
              color: Colors.indigo,
              onTap: () {},
            ),
            QuickAccessButton(
              title: 'Thông báo',
              icon: Icons.notifications,
              color: Colors.amber,
              onTap: () {},
            ),
            QuickAccessButton(
              title: 'Báo cáo',
              icon: Icons.analytics,
              color: Colors.purple,
              onTap: () {},
            ),
            QuickAccessButton(
              title: 'Cài đặt',
              icon: Icons.settings,
              color: Colors.grey,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsPreview(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Báo cáo & Phân tích',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('Xem tất cả')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAnalyticItem(
                    'Tỷ lệ chuyên cần',
                    '92.5%',
                    Colors.green,
                    Icons.trending_up,
                  ),
                ),
                Expanded(
                  child: _buildAnalyticItem(
                    'Học phí đúng hạn',
                    '88.2%',
                    Colors.orange,
                    Icons.trending_down,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticItem(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
