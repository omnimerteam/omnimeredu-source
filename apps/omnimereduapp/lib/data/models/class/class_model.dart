import '../../../domain/entities/class/class_entity.dart';

class ClassModel {
  final String? id;
  final String? name;
  final String? code;
  final String? schoolId;
  final String? gradeId;
  final int? maxStudents;
  final int? baseFee;
  final List<String>? students;

  const ClassModel({
    this.id,
    this.name,
    this.code,
    this.schoolId,
    this.gradeId,
    this.maxStudents,
    this.baseFee,
    this.students,
  });

  /// JSON -> Model
  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      gradeId: json['gradeId'] as String?,
      schoolId: json['schoolId'] as String?,
      maxStudents: json['maxStudents'] is int
          ? json['maxStudents'] as int
          : int.tryParse(json['maxStudents']?.toString() ?? ''),
      baseFee: json['baseFee'] is int
          ? json['baseFee'] as int
          : int.tryParse(json['baseFee']?.toString() ?? ''),
      students: (json['students'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  /// Model -> JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'code': code,
      'schoolId': schoolId,
      'gradeId': gradeId,
      'maxStudents': maxStudents,
      'baseFee': baseFee,
      'students': students,
    };
  }

  /// Model -> Entity (Data -> Domain)
  ClassEntity toEntity() {
    return ClassEntity(
      id: id,
      name: name,
      code: code,
      schoolId: schoolId,
      gradeId: gradeId,
      maxStudents: maxStudents,
      baseFee: baseFee,
      students: students,
    );
  }

  /// Entity -> Model (Domain -> Data, ví dụ cache/local)
  factory ClassModel.fromEntity(ClassEntity entity) {
    return ClassModel(
      id: entity.id,
      name: entity.name,
      code: entity.code,
      schoolId: entity.schoolId,
      gradeId: entity.gradeId,
      maxStudents: entity.maxStudents,
      baseFee: entity.baseFee,
      students: entity.students,
    );
  }
}
