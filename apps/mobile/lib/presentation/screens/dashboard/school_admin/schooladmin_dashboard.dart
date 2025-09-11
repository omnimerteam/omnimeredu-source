import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/school_admin_dashboard_data_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/widgets/chart/attendance_chart.dart';
import 'widgets/dashboard_quick_overview.dart';
import 'widgets/dashboard_quick_access.dart';
import 'widgets/dashboard_analytics_preview.dart';

class SchoolAdminDashboard extends StatelessWidget {
  final SchoolAdminDashboardDataEntity data;

  const SchoolAdminDashboard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardQuickOverview(overview: data.overview),
        const SizedBox(height: 24),
        AttendanceChart(
          classAttendanceRates: data.attendanceStats.classAttendanceRates,
        ),
        const SizedBox(height: 24),
        const DashboardQuickAccess(),
        const SizedBox(height: 24),
        const DashboardAnalyticsPreview(),
      ],
    );
  }
}
