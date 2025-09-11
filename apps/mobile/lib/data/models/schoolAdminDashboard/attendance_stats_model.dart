import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/attendance_stats_entity.dart';

class AttendanceStatsModel extends AttendanceStatsEntity {
  const AttendanceStatsModel({
    required super.attendanceRate,
    required super.classAttendanceRates,
    required super.date,
  });

  factory AttendanceStatsModel.fromJson(Map<String, dynamic> json) {
    return AttendanceStatsModel(
      attendanceRate: (json['attendanceRate'] ?? 0.0).toDouble(),
      classAttendanceRates: Map<String, double>.from(
        json['classAttendanceRates'] ?? {},
      ),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() => {
    'attendanceRate': attendanceRate,
    'classAttendanceRates': classAttendanceRates,
    'date': date.toIso8601String(),
  };

  AttendanceStatsEntity toEntity() {
    return AttendanceStatsEntity(
      attendanceRate: attendanceRate,
      classAttendanceRates: classAttendanceRates,
      date: date,
    );
  }
}
