import '../../../core/constants/app_constant.dart';
import '../../../core/constants/enum_constant.dart';
import '../../../domain/entities/grade/grade_entity.dart';

/// 🔹 Data Model cho Grade (thuộc Data Layer)
/// Tách biệt với [GradeEntity] của Domain Layer
class GradeModel {
  final String? id;
  final String schoolId;
  final String name;
  final EducationSystemLevelsEnum level;
  final EducationGradesEnum gradeGroup;
  final int order;
  final Map<String, int>? ageRange;
  final String? description;
  final bool active;
  final List<String>? linkedClasses;
  final Map<String, dynamic>? customFields;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GradeModel({
    this.id,
    required this.schoolId,
    required this.name,
    required this.level,
    required this.gradeGroup,
    required this.order,
    this.ageRange,
    this.description,
    this.active = true,
    this.linkedClasses,
    this.customFields,
    this.createdAt,
    this.updatedAt,
  });

  /// 🔹 Parse từ JSON (backend → model)
  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['_id'] as String?,
      schoolId: json['schoolId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      level: EducationSystemLevelsEnum.fromString(json['level'] as String?),
      gradeGroup: EducationGradesEnum.fromString(json['gradeGroup'] as String?),
      order: json['order'] as int? ?? 0,
      ageRange: (json['ageRange'] as Map?)?.cast<String, int>(),
      description: json['description'] as String?,
      active: json['active'] as bool? ?? true,
      linkedClasses: (json['linkedClasses'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      customFields: (json['customFields'] as Map?)?.cast<String, dynamic>(),
      createdAt: (json['createdAt'] as String?) != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['createdAt'] as String)!,
            )
          : null,
      updatedAt: (json['updatedAt'] as String?) != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['updatedAt'] as String)!,
            )
          : null,
    );
  }

  /// 🔹 Convert sang JSON (model → backend)
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
    };
  }

  /// 🔹 Model → Entity (dùng trong Domain/Bloc)
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

  /// 🔹 Entity → Model (dùng khi gọi API hoặc DB)
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
