import '../../entities/dashboard/school_admin/attendance_stats_entity.dart';
import '../../repositories/dashboard/school_admin_dashboard_repository.dart';

class GetSchoolAttendanceStatsUseCase {
  final SchoolAdminDashboardRepository repository;

  GetSchoolAttendanceStatsUseCase(this.repository);

  Future<AttendanceStatsEntity> call() async {
    return await repository.getSchoolAttendanceStats();
  }
}
