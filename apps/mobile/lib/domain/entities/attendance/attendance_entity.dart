import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';

/// 🔹 AttendanceEntity - Đại diện dữ liệu điểm danh ở tầng domain
class AttendanceEntity extends Equatable {
  final String? id;
  final String? classId;
  final String? schoolId;
  final DateTime? date;
  final AttendanceSessionTypeEnum? sessionType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AttendanceEntity({
    this.id,
    this.classId,
    this.schoolId,
    this.date,
    this.sessionType,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    classId,
    schoolId,
    date,
    sessionType,
    createdAt,
    updatedAt,
  ];
}
