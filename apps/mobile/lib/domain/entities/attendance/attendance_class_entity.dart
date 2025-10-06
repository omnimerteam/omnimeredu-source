import 'package:equatable/equatable.dart';

/// 🔹 AttendanceEntity - Đại diện dữ liệu điểm danh ở tầng domain
class AttendanceClassEntity extends Equatable {
  final String id;
  final ClassAttendanceEntity classId;
  final String schoolId;
  final DateTime date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AttendanceClassEntity({
    required this.id,
    required this.classId,
    required this.schoolId,
    required this.date,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    classId,
    schoolId,
    date,
    createdAt,
    updatedAt,
  ];
}

class ClassAttendanceEntity extends Equatable {
  final String id;
  final String name;
  final String code;

  const ClassAttendanceEntity({
    required this.id,
    required this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}
