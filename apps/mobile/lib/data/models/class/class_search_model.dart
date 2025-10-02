import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';

/// 🔹 Model cho ClassSearchEntity
class ClassSearchModel {
  final String id;
  final String name;
  final String code;
  final String schoolId;
  final String gradeId;
  final EducationGradesEnum gradeGroup;

  const ClassSearchModel({
    required this.id,
    required this.name,
    required this.code,
    required this.schoolId,
    required this.gradeId,
    required this.gradeGroup,
  });

  /// Map JSON → Model
  factory ClassSearchModel.fromJson(Map<String, dynamic> json) {
    return ClassSearchModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      schoolId: json['schoolId'] as String,
      gradeId: json['gradeId'] as String,
      gradeGroup: EducationGradesEnum.fromString(json['gradeGroup'] as String),
    );
  }

  /// Map Model → JSON (nếu cần gửi API)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'code': code,
      'schoolId': schoolId,
      'gradeId': gradeId,
      'gradeGroup': gradeGroup.name, // enum -> string
    };
  }

  /// Convert Model → Entity
  ClassSearchEntity toEntity() {
    return ClassSearchEntity(
      id: id,
      name: name,
      code: code,
      schoolId: schoolId,
      gradeId: gradeId,
      gradeGroup: gradeGroup,
    );
  }

  /// Convert Entity → Model (nếu cần)
  factory ClassSearchModel.fromEntity(ClassSearchEntity entity) {
    return ClassSearchModel(
      id: entity.id,
      name: entity.name,
      code: entity.code,
      schoolId: entity.schoolId,
      gradeId: entity.gradeId,
      gradeGroup: entity.gradeGroup,
    );
  }
}
