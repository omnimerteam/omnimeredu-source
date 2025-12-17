import 'package:mobile/core/constants/enum_constant.dart';
import 'package:mobile/domain/entities/class/class_entity.dart';

class ClassModel extends ClassEntity {
  const ClassModel({
    required super.id,
    required super.name,
    super.code,
    required super.schoolId,
    required super.gradeId,
    super.maxStudents,
    required super.currentStudents,
    required super.baseFee,
    super.createdAt,
    super.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String?,
      schoolId: json['schoolId'] as String,
      gradeId: json['gradeId'] as String,
      maxStudents: json['maxStudents'] as int?,
      currentStudents: (json['currentStudents'] as int?) ?? 0,
      baseFee: json['baseFee'] as num,
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
      if (code != null) 'code': code,
      'schoolId': schoolId,
      'gradeId': gradeId,
      'maxStudents': maxStudents,
      'currentStudents': currentStudents,
      'baseFee': baseFee,
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
      gradeId: gradeId,
      maxStudents: maxStudents,
      currentStudents: currentStudents,
      baseFee: baseFee,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
