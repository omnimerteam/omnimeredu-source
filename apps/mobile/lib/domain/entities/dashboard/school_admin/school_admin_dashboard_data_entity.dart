import 'package:flutter_ios_android_platforms/domain/entities/dashboard/dashboard_data_base_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/class_state_entity.dart';
import 'dashboard_overview_entity.dart';

class SchoolAdminDashboardDataEntity extends DashboardDataBaseEntity {
  final DashboardOverviewEntity overview;
  final AttendanceStatsEntity attendanceStats;

  const SchoolAdminDashboardDataEntity({
    required this.overview,
    required this.attendanceStats,
    required DateTime cachedAt,
  }) : super(cachedAt: cachedAt);

  @override
  Map<String, dynamic> toJson() => {
    'overview': overview.toJson(),
    'attendanceStats': attendanceStats.toJson(),
    'cachedAt': cachedAt.toIso8601String(),
  };

  factory SchoolAdminDashboardDataEntity.fromJson(Map<String, dynamic> json) {
    return SchoolAdminDashboardDataEntity(
      overview: DashboardOverviewEntity.fromJson(json['overview']),
      attendanceStats: AttendanceStatsEntity.fromJson(json['attendanceStats']),
      cachedAt: DateTime.parse(json['cachedAt']),
    );
  }

  SchoolAdminDashboardDataEntity copyWith({
    DashboardOverviewEntity? overview,
    AttendanceStatsEntity? attendanceStats,
    DateTime? cachedAt,
  }) {
    return SchoolAdminDashboardDataEntity(
      overview: overview ?? this.overview,
      attendanceStats: attendanceStats ?? this.attendanceStats,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }
}
