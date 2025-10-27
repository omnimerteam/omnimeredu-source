import '../../entities/dashboard/school_admin/dashboard_overview_entity.dart';
import '../../entities/dashboard/school_admin/attendance_stats_entity.dart';

abstract class SchoolAdminDashboardRepository {
  Future<DashboardOverviewEntity> getSummary();
  Future<AttendanceStatsEntity> getSchoolAttendanceStats();
}
