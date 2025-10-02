import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';

/// 🔹 Entity chính: ClassDetailView
class ClassDetailViewEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final int? baseFee;

  final SchoolClassDetailEntity? school;
  final GradeClassDetailEntity? grade;
  final List<TeacherClassDetailEntity>? teachers;
  final List<StudentClassDetailEntity>? students;

  const ClassDetailViewEntity({
    required this.id,
    required this.name,
    required this.code,
    this.baseFee,
    this.school,
    this.grade,
    this.teachers,
    this.students,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    baseFee,
    school,
    grade,
    teachers,
    students,
  ];
}

/// 🔹 Thông tin trường
class SchoolClassDetailEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final EducationSystemLevelsEnum level;

  const SchoolClassDetailEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.level,
  });

  @override
  List<Object?> get props => [id, name, code, level];
}

/// 🔹 Thông tin khối (Grade)
class GradeClassDetailEntity extends Equatable {
  final String id;
  final String name;
  final EducationSystemLevelsEnum level;
  final EducationGradesEnum gradeGroup;

  const GradeClassDetailEntity({
    required this.id,
    required this.name,
    required this.level,
    required this.gradeGroup,
  });

  @override
  List<Object?> get props => [id, name, level, gradeGroup];
}

/// 🔹 Thông tin giáo viên (có thể nhiều, có cờ isMain)
class TeacherClassDetailEntity extends Equatable {
  final String id;
  final String fullName;
  final SubjectEnum? subject;
  final TeacherQualificationEnum? qualification;
  final bool isMain;

  const TeacherClassDetailEntity({
    required this.id,
    required this.fullName,
    this.subject,
    this.qualification,
    required this.isMain,
  });

  @override
  List<Object?> get props => [id, fullName, subject, qualification, isMain];
}

/// 🔹 Thông tin học sinh
class StudentClassDetailEntity extends Equatable {
  final String id;
  final String fullName;
  final String? gender;
  final String? phone;
  final String? address;
  final String? guardianName;
  final String? guardianPhone;

  const StudentClassDetailEntity({
    required this.id,
    required this.fullName,
    this.gender,
    this.phone,
    this.address,
    this.guardianName,
    this.guardianPhone,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    gender,
    phone,
    address,
    guardianName,
    guardianPhone,
  ];
}
