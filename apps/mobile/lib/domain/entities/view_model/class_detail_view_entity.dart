import 'package:equatable/equatable.dart';

class ClassDetailViewEntity extends Equatable {
  final String? id;
  final String? name;
  final String? code;
  final int? baseFee;

  final SchoolClassDetailView? school;
  final GradeClassDetailView? grade;
  final MainTeacherClassDetailView? mainTeacher;
  final List<StudentClassDetailView>? students;

  const ClassDetailViewEntity({
    this.id,
    this.name,
    this.code,
    this.baseFee,
    this.school,
    this.grade,
    this.mainTeacher,
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
    mainTeacher,
    students,
  ];
}

class SchoolClassDetailView extends Equatable {
  final String? id;
  final String? name;
  final String? code;
  final String? level;

  const SchoolClassDetailView({this.id, this.name, this.code, this.level});

  @override
  List<Object?> get props => [id, name, code, level];
}

class GradeClassDetailView extends Equatable {
  final String? id;
  final String? name;
  final String? level;

  const GradeClassDetailView({this.id, this.name, this.level});

  @override
  List<Object?> get props => [id, name, level];
}

class MainTeacherClassDetailView extends Equatable {
  final String? id;
  final String? fullName;
  final String? literacy;
  final String? qualification;

  const MainTeacherClassDetailView({
    this.id,
    this.fullName,
    this.literacy,
    this.qualification,
  });

  @override
  List<Object?> get props => [id, fullName, literacy, qualification];
}

class StudentClassDetailView extends Equatable {
  final String? id;
  final String? fullName;
  final String? gender;
  final String? phone;
  final String? guardianName;
  final String? guardianPhone;

  const StudentClassDetailView({
    this.id,
    this.fullName,
    this.gender,
    this.phone,
    this.guardianName,
    this.guardianPhone,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    gender,
    phone,
    guardianName,
    guardianPhone,
  ];
}
