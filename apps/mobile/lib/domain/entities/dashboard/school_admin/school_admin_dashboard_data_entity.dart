import 'package:flutter_ios_android_platforms/domain/entities/dashboard/dashboard_data_base_entity.dart';
import 'dashboard_overview_entity.dart';
import 'attendance_stats_entity.dart';

class SchoolAdminDashboardDataEntity extends DashboardDataBaseEntity {
  final DashboardOverviewEntity overview;
  final AttendanceStatsEntity attendanceStats;

  SchoolAdminDashboardDataEntity({
    required this.overview,
    required this.attendanceStats,
    required DateTime cachedAt,
  }) : super(cachedAt: cachedAt);

  // /// Convert Entity -> Map (dùng để cache)
  @override
  Map<String, dynamic> toJson() => {
    'overview': overview.toJson(),
    'attendanceStats': attendanceStats.toJson(),
    'cachedAt': cachedAt.toIso8601String(),
  };

  /// Convert Map -> Entity (dùng khi load cache)
  factory SchoolAdminDashboardDataEntity.fromJson(Map<String, dynamic> json) {
    return SchoolAdminDashboardDataEntity(
      overview: DashboardOverviewEntity.fromJson(json['overview']),
      attendanceStats: AttendanceStatsEntity.fromJson(json['attendanceStats']),
      cachedAt: DateTime.parse(json['cachedAt']),
    );
  }

  /// Copy với cachedAt mới (dùng trong cache)
  @override
  DashboardDataBaseEntity copyWith({required DateTime cachedAt}) {
    return SchoolAdminDashboardDataEntity(
      overview: overview,
      attendanceStats: attendanceStats,
      cachedAt: cachedAt,
    );
  }
}
