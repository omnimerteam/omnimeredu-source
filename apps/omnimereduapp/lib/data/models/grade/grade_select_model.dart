import '../../../domain/entities/grade/grade_select_entity.dart';
import '../../../core/constants/enum_constant.dart';

class GradeSelectModel extends GradeSelectEntity {
  const GradeSelectModel({
    required String id,
    required String name,
    required EducationSystemLevelsEnum level,
    required int order,
    Map<String, int>? ageRange,
  }) : super(
         id: id,
         name: name,
         level: level,
         order: order,
         ageRange: ageRange,
       );

  factory GradeSelectModel.fromJson(Map<String, dynamic> json) {
    return GradeSelectModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      level: EducationSystemLevelsEnum.fromString(json['level'] as String),
      order: json['order'] as int,
      ageRange: json['ageRange'] != null
          ? Map<String, int>.from(json['ageRange'] as Map)
          : null,
    );
  }

  GradeSelectEntity toEntity() {
    return GradeSelectEntity(
      id: id,
      name: name,
      level: level,
      order: order,
      ageRange: ageRange,
    );
  }
}
