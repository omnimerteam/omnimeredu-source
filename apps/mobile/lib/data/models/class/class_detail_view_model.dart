import 'package:decimal/decimal.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_detail_view_entity.dart';

class ClassDetailViewModel extends ClassDetailViewEntity {
  const ClassDetailViewModel({
    String? id,
    String? name,
    String? code,
    int? baseFee,
    int? studentCount,
    String? schoolId,
    String? schoolName,
    String? schoolLevel,
    String? teacherId,
    String? teacherName,
  }) : super(
         id: id,
         name: name,
         code: code,
         baseFee: baseFee,
         studentCount: studentCount,
         schoolId: schoolId,
         schoolName: schoolName,
         schoolLevel: schoolLevel,
         teacherId: teacherId,
         teacherName: teacherName,
       );

  factory ClassDetailViewModel.fromJson(Map<String, dynamic> json) {
    return ClassDetailViewModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      baseFee: json['baseFee'] as int?,
      schoolId: json['schoolId'] as String?,
      studentCount: json['studentCount'] as int?,
      schoolName: json['schoolName'] as String?,
      schoolLevel: json['schoolLevel'] as String?,
      teacherId: json['teacherId'] as String?,
      teacherName: json['teacherName'] as String?,
    );
  }

  ClassDetailViewEntity toEntity() {
    return ClassDetailViewEntity(
      id: id,
      name: name,
      code: code,
      baseFee: baseFee,
      studentCount: studentCount,
      schoolId: schoolId,
      schoolName: schoolName,
      schoolLevel: schoolLevel,
      teacherId: teacherId,
      teacherName: teacherName,
    );
  }
}
