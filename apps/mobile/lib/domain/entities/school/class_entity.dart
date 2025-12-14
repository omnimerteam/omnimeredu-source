import 'package:equatable/equatable.dart';
import '../../../core/constants/enum_constant.dart';

class ClassEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final String schoolId;
  final EducationGradesEnum grade;
  final EducationSystemLevelsEnum level;
  final int? maxStudents;
  final int currentStudents;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ClassEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.schoolId,
    required this.grade,
    required this.level,
    this.maxStudents,
    required this.currentStudents,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        schoolId,
        grade,
        level,
        maxStudents,
        currentStudents,
        createdAt,
        updatedAt,
      ];
}