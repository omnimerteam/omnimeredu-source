import 'package:equatable/equatable.dart';

class ClassEntity extends Equatable {
  final String? id;
  final String? name;
  final String? code;
  final String? schoolId;
  final String? gradeId;
  final int? maxStudents;
  final int? baseFee;
  final List<String>? students; // 🔹 danh sách id học sinh

  const ClassEntity({
    this.id,
    this.name,
    this.code,
    this.schoolId,
    this.gradeId,
    this.maxStudents,
    this.baseFee,
    this.students,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    schoolId,
    gradeId,
    maxStudents,
    baseFee,
    students,
  ];
}
