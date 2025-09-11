class AttendanceStatsEntity {
  final double attendanceRate;
  final Map<String, double> classAttendanceRates;
  final DateTime date;

  const AttendanceStatsEntity({
    required this.attendanceRate,
    required this.classAttendanceRates,
    required this.date,
  });

  /// Convert Entity -> Map
  Map<String, dynamic> toJson() => {
    'attendanceRate': attendanceRate,
    'classAttendanceRates': classAttendanceRates,
    'date': date.toIso8601String(),
  };

  /// Convert Map -> Entity
  factory AttendanceStatsEntity.fromJson(Map<String, dynamic> json) {
    final rates = Map<String, double>.from(
      (json['classAttendanceRates'] ?? {}).map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
    );

    return AttendanceStatsEntity(
      attendanceRate: (json['attendanceRate'] as num?)?.toDouble() ?? 0,
      classAttendanceRates: rates,
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    );
  }
}
