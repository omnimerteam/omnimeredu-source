import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_entity.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';

class GradeModel extends GradeEntity {
  const GradeModel({
    String? id,
    required String schoolId,
    required String name,
    required EducationSystemLevelsEnum level,
    required EducationGradesEnum gradeGroup,
    required int order,
    Map<String, int>? ageRange,
    String? description,
    bool active = true,
    List<String>? linkedClasses,
    Map<String, dynamic>? customFields,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
         id: id,
         schoolId: schoolId,
         name: name,
         level: level,
         gradeGroup: gradeGroup,
         order: order,
         ageRange: ageRange,
         description: description,
         active: active,
         linkedClasses: linkedClasses,
         customFields: customFields,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['_id'] as String,
      schoolId: json['schoolId'] as String,
      name: json['name'] as String,
      level: EducationSystemLevelsEnum.fromString(json['level'] as String),
      gradeGroup: EducationGradesEnum.fromString(json['gradeGroup'] as String),
      order: json['order'] as int,
      ageRange: json['ageRange'] != null
          ? Map<String, int>.from(json['ageRange'] as Map)
          : null,
      description: json['description'] as String?,
      active: json['active'] as bool? ?? true,
      linkedClasses: (json['linkedClasses'] as List?)
          ?.map((e) => e as String)
          .toList(),
      customFields: json['customFields'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'schoolId': schoolId,
      'name': name,
      'level': level.name,
      'gradeGroup': gradeGroup.name,
      'order': order,
      'ageRange': ageRange,
      'description': description,
      'active': active,
      'linkedClasses': linkedClasses,
      'customFields': customFields,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  GradeEntity toEntity() {
    return GradeEntity(
      id: id,
      schoolId: schoolId,
      name: name,
      level: level,
      gradeGroup: gradeGroup,
      order: order,
      ageRange: ageRange,
      description: description,
      active: active,
      linkedClasses: linkedClasses,
      customFields: customFields,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory GradeModel.fromEntity(GradeEntity entity) {
    return GradeModel(
      id: entity.id,
      schoolId: entity.schoolId,
      name: entity.name,
      level: entity.level,
      gradeGroup: entity.gradeGroup,
      order: entity.order,
      ageRange: entity.ageRange,
      description: entity.description,
      active: entity.active,
      linkedClasses: entity.linkedClasses,
      customFields: entity.customFields,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
