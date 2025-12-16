import '../../../core/constants/enum_constant.dart';
import '../../../domain/entities/grade/grade_entity.dart';

class GradeModel extends GradeEntity {
  const GradeModel({
    super.id,
    required super.schoolId,
    required super.name,
    required super.level,
    required super.gradeGroup,
    required super.order,
    super.ageRange,
    super.description,
    super.active,
    super.linkedClasses,
    super.customFields,
    super.createdAt,
    super.updatedAt,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    // Parse nested map for ageRange if exists
    Map<String, int>? ageRangeMap;
    if (json['ageRange'] != null) {
      ageRangeMap = Map<String, int>.from(json['ageRange']);
    }

    return GradeModel(
      id: json['_id'] as String?,
      schoolId: json['schoolId'] as String,
      name: json['name'] as String,
      level: EducationSystemLevelsEnum.fromString(json['level']),
      gradeGroup: EducationGradesEnum.fromString(json['gradeGroup']),
      order: json['order'] as int,
      ageRange: ageRangeMap,
      description: json['description'] as String?,
      active: json['active'] as bool? ?? true,
      linkedClasses: (json['linkedClasses'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      customFields: json['customFields'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'schoolId': schoolId,
      'name': name,
      'level': level.asString,
      'gradeGroup': gradeGroup.name,
      'order': order,
      if (ageRange != null) 'ageRange': ageRange,
      if (description != null) 'description': description,
      'active': active,
      if (linkedClasses != null) 'linkedClasses': linkedClasses,
      if (customFields != null) 'customFields': customFields,
      // createdAt/updatedAt are usually improved by backend
    };
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
