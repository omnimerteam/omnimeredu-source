import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/dashboard_overview_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/attendance_stats_entity.dart';

abstract class SchoolAdminDashboardRepository {
  Future<DashboardOverviewEntity> getSummary();
  Future<AttendanceStatsEntity> getSchoolAttendanceStats();
}
