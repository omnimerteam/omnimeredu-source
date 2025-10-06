import 'package:equatable/equatable.dart';

class AttendanceStatsEntity extends Equatable {
  final List<ClassStatsEntity> classAttendanceRates;

  const AttendanceStatsEntity({required this.classAttendanceRates});

  /// Convert Entity -> Map
  Map<String, dynamic> toJson() => {
    'classAttendanceRates': classAttendanceRates
        .map((e) => e.toJson())
        .toList(),
  };

  /// Convert Map -> Entity
  factory AttendanceStatsEntity.fromJson(Map<String, dynamic> json) {
    final list = (json['classAttendanceRates'] as List<dynamic>? ?? [])
        .map((e) => ClassStatsEntity.fromJson(e as Map<String, dynamic>))
        .toList();

    return AttendanceStatsEntity(classAttendanceRates: list);
  }

  @override
  List<Object?> get props => [classAttendanceRates];
}

class ClassStatsEntity extends Equatable {
  final String className;
  final int total;
  final int present;
  final int absentWithLeave;
  final int absent;
  final int late;
  final int leftEarly;

  const ClassStatsEntity({
    required this.className,
    required this.total,
    required this.present,
    required this.absentWithLeave,
    required this.absent,
    required this.late,
    required this.leftEarly,
  });

  /// Convert Entity -> Map
  Map<String, dynamic> toJson() => {
    'className': className,
    'total': total,
    'present': present,
    'absentWithLeave': absentWithLeave,
    'absent': absent,
    'late': late,
    'leftEarly': leftEarly,
  };

  /// Convert Map -> Entity
  factory ClassStatsEntity.fromJson(Map<String, dynamic> json) {
    return ClassStatsEntity(
      className: json['className'] ?? '',
      total: json['total'] ?? 0,
      present: json['present'] ?? 0,
      absentWithLeave: json['absentWithLeave'] ?? 0,
      absent: json['absent'] ?? 0,
      late: json['late'] ?? 0,
      leftEarly: json['leftEarly'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    className,
    total,
    present,
    absentWithLeave,
    absent,
    late,
    leftEarly,
  ];
}
