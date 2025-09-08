class AttendanceStatsEntity {
  final double attendanceRate;
  final Map<String, double> classAttendanceRates;
  final DateTime date;

  const AttendanceStatsEntity({
    required this.attendanceRate,
    required this.classAttendanceRates,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'attendanceRate': attendanceRate,
    'classAttendanceRates': classAttendanceRates,
    'date': date.toIso8601String(),
  };

  factory AttendanceStatsEntity.fromJson(Map<String, dynamic> json) =>
      AttendanceStatsEntity(
        attendanceRate: (json['attendanceRate'] ?? 0.0).toDouble(),
        classAttendanceRates: Map<String, double>.from(
          json['classAttendanceRates'] ?? {},
        ),
        date: DateTime.parse(json['date']),
      );
}
