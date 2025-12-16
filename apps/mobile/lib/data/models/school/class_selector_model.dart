import '../../../../core/constants/enum_constant.dart';
import '../../../domain/entities/class/class_selector_entity.dart';

class ClassSelectorModel extends ClassSelectorEntity {
  const ClassSelectorModel({
    required super.id,
    required super.name,
    required super.code,
    required super.schoolId,
    required super.gradeId,
    required super.gradeGroup,
  });

  factory ClassSelectorModel.fromJson(Map<String, dynamic> json) {
    return ClassSelectorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      schoolId: json['schoolId'] as String,
      gradeId: json['gradeId'] as String? ?? '',
      gradeGroup: EducationGradesEnum.fromString(json['grade']),
    );
  }
}
