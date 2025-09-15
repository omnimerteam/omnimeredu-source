import 'package:flutter_ios_android_platforms/data/datasources/remote/dashboard/school_admin_dashboard_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/dashboard_overview_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/attendance_stats_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/dashboard/school_admin_dashboard_repository.dart';

class SchoolAdminDashboardRepositoryImpl
    implements SchoolAdminDashboardRepository {
  final SchoolAdminDashboardRemoteDataSource remoteDataSource;

  SchoolAdminDashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<DashboardOverviewEntity> getSummary() async {
    final model = await remoteDataSource.getSummary();
    return model.toEntity();
  }

  @override
  Future<AttendanceStatsEntity> getSchoolAttendanceStats() async {
    final model = await remoteDataSource.getSchoolAttendanceStats();
    return model.toEntity();
  }
}
