import '../../../domain/entities/dashboard/school_admin/attendance_stats_entity.dart';

class AttendanceStatsModel extends AttendanceStatsEntity {
  const AttendanceStatsModel({required super.classAttendanceRates});

  /// Parse JSON -> Model
  factory AttendanceStatsModel.fromJson(Map<String, dynamic> json) {
    final list = (json['classAttendanceRates'] as List<dynamic>? ?? [])
        .map((e) => ClassStatsModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return AttendanceStatsModel(classAttendanceRates: list);
  }

  /// Convert Model -> JSON
  Map<String, dynamic> toJson() => {
    'classAttendanceRates': classAttendanceRates
        .map((e) => (e as ClassStatsModel).toJson())
        .toList(),
  };

  /// Convert Model -> Entity
  AttendanceStatsEntity toEntity() =>
      AttendanceStatsEntity(classAttendanceRates: classAttendanceRates);
}

class ClassStatsModel extends ClassStatsEntity {
  const ClassStatsModel({
    required super.className,
    required super.total,
    required super.present,
    required super.absentWithLeave,
    required super.absent,
    required super.late,
    required super.leftEarly,
  });

  /// Parse JSON -> Model
  factory ClassStatsModel.fromJson(Map<String, dynamic> json) {
    return ClassStatsModel(
      className: json['className'] ?? '',
      total: json['total'] ?? 0,
      present: json['present'] ?? 0,
      absentWithLeave: json['absentWithLeave'] ?? 0,
      absent: json['absent'] ?? 0,
      late: json['late'] ?? 0,
      leftEarly: json['leftEarly'] ?? 0,
    );
  }

  /// Convert Model -> JSON
  Map<String, dynamic> toJson() => {
    'className': className,
    'total': total,
    'present': present,
    'absentWithLeave': absentWithLeave,
    'absent': absent,
    'late': late,
    'leftEarly': leftEarly,
  };

  /// Convert Model -> Entity
  ClassStatsEntity toEntity() => ClassStatsEntity(
    className: className,
    total: total,
    present: present,
    absentWithLeave: absentWithLeave,
    absent: absent,
    late: late,
    leftEarly: leftEarly,
  );
}
