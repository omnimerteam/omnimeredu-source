import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/attendance_stats_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/dashboard/school_admin_dashboard_repository.dart';

class GetSchoolAttendanceStatsUseCase {
  final SchoolAdminDashboardRepository repository;

  GetSchoolAttendanceStatsUseCase(this.repository);

  Future<AttendanceStatsEntity> call() {
    return repository.getSchoolAttendanceStats();
  }
}
