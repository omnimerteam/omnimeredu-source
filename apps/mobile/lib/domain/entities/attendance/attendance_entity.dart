import 'package:equatable/equatable.dart';

/// 🔹 AttendanceEntity - Đại diện dữ liệu điểm danh ở tầng domain
class AttendanceEntity extends Equatable {
  final String? id;
  final String? classId;
  final String? schoolId;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AttendanceEntity({
    this.id,
    this.classId,
    this.schoolId,
    this.date,
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
