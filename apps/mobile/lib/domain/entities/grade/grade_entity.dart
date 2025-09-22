import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';

class GradeEntity extends Equatable {
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

  const GradeEntity({
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

  @override
  List<Object?> get props => [
    id,
    schoolId,
    name,
    level,
    gradeGroup,
    order,
    ageRange,
    description,
    active,
    linkedClasses,
    customFields,
    createdAt,
    updatedAt,
  ];

  GradeEntity copyWith({
    String? id,
    String? schoolId,
    String? name,
    EducationSystemLevelsEnum? level,
    EducationGradesEnum? gradeGroup,
    int? order,
    Map<String, int>? ageRange,
    String? description,
    bool? active,
    List<String>? linkedClasses,
    Map<String, dynamic>? customFields,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GradeEntity(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      name: name ?? this.name,
      level: level ?? this.level,
      gradeGroup: gradeGroup ?? this.gradeGroup,
      order: order ?? this.order,
      ageRange: ageRange ?? this.ageRange,
      description: description ?? this.description,
      active: active ?? this.active,
      linkedClasses: linkedClasses ?? this.linkedClasses,
      customFields: customFields ?? this.customFields,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
