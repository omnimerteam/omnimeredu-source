import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';

/// 🔹 Entity cho từng học sinh trong attendance
class StudentAttendanceEntity extends Equatable {
  final String id;
  final String name;
  final String? phone;
  final String guardianName;
  final String guardianPhone;
  final String? gender;
  final DateTime? birthday;
  final String detailRecordId;
  final AttendanceStatusEnum status;
  final String? note;

  const StudentAttendanceEntity({
    required this.id,
    required this.name,
    this.phone,
    required this.guardianName,
    required this.guardianPhone,
    this.gender,
    this.birthday,
    required this.detailRecordId,
    required this.status,
    this.note,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    guardianName,
    guardianPhone,
    gender,
    birthday,
    detailRecordId,
    status,
    note,
  ];
}

/// 🔹 Thông tin class trong attendance record
class AttendanceClassInfoEntity extends Equatable {
  final String id;
  final String name;
  final String code;

  const AttendanceClassInfoEntity({
    required this.id,
    required this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}

/// 🔹 Thông tin school trong attendance record
class AttendanceSchoolInfoEntity extends Equatable {
  final String id;
  final String name;
  final String code;

  const AttendanceSchoolInfoEntity({
    required this.id,
    required this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}

/// 🔹 Entity chính: AttendanceRecordView
class AttendanceRecordViewEntity extends Equatable {
  final String id;
  final String classId;
  final String schoolId;
  final AttendanceClassInfoEntity classInfo;
  final AttendanceSchoolInfoEntity schoolInfo;
  final DateTime date;
  final List<StudentAttendanceEntity> students;

  const AttendanceRecordViewEntity({
    required this.id,
    required this.classId,
    required this.schoolId,
    required this.classInfo,
    required this.schoolInfo,
    required this.date,
    required this.students,
  });

  @override
  List<Object?> get props => [
    id,
    classId,
    schoolId,
    classInfo,
    schoolInfo,
    date,
    students,
  ];
}
