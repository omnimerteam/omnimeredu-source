import '../../../../core/constants/enum_constant.dart';
import '../../../domain/entities/class/class_entity.dart';

class ClassModel extends ClassEntity {
  const ClassModel({
    required super.id,
    required super.name,
    required super.code,
    required super.schoolId,
    required super.grade,
    required super.level,
    super.maxStudents,
    super.currentStudents = 0,
    super.createdAt,
    super.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      schoolId: json['schoolId'] as String,
      grade: EducationGradesEnum.fromString(json['grade']),
      level: EducationSystemLevelsEnum.fromString(json['level']),
      maxStudents: json['maxStudents'] as int?,
      currentStudents: (json['currentStudents'] as int?) ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'schoolId': schoolId,
      'grade': grade.name,
      'level': level.name,
      'maxStudents': maxStudents,
      'currentStudents': currentStudents,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ClassEntity toEntity() {
    return ClassEntity(
      id: id,
      name: name,
      code: code,
      schoolId: schoolId,
      grade: grade,
      level: level,
      maxStudents: maxStudents,
      currentStudents: currentStudents,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
