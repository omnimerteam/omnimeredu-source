import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';

class ClassModel extends ClassEntity {
  const ClassModel({
    String? id,
    String? name,
    String? code,
    String? schoolId,
    String? gradeId,
    int? maxStudents,
    int? baseFee,
    List<String>? students,
  }) : super(
         id: id,
         name: name,
         code: code,
         schoolId: schoolId,
         gradeId: gradeId,
         maxStudents: maxStudents,
         baseFee: baseFee,
         students: students,
       );

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      gradeId: json['gradeId'] as String?,
      schoolId: json['schoolId'] as String?,
      maxStudents: json['maxStudents'] as int?,
      baseFee: json['baseFee'] as int?,
      students: (json['students'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'code': code,
      'schoolId': schoolId,
      'gradeId': gradeId,
      'maxStudents': maxStudents,
      'baseFee': baseFee?.toDouble(),
      'students': students,
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
      baseFee: baseFee,
      students: students,
    );
  }

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
