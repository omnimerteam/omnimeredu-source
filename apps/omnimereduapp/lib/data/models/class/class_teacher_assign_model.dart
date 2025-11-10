import '../../../core/constants/app_constant.dart';
import '../../../core/constants/enum_constant.dart';
import '../../../domain/entities/teaching_assignment/class_teacher_assign_entity.dart';

class ClassTeacherAssignModel {
  final String? id;
  final String teacherId;
  final AssignedClassEntity classEntity;
  final String schoolId;
  final SubjectEnum subject;
  final bool isMain;
  final bool isHaveAttendance;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ClassTeacherAssignModel({
    this.id,
    required this.teacherId,
    required this.classEntity,
    required this.schoolId,
    required this.subject,
    required this.isMain,
    required this.isHaveAttendance,
    this.createdAt,
    this.updatedAt,
  });

  factory ClassTeacherAssignModel.fromJson(Map<String, dynamic> json) {
    return ClassTeacherAssignModel(
      id: json['_id'] as String?,
      teacherId: json['teacherId'] as String? ?? '',
      classEntity: AssignedClassEntity.fromJson(json['classId']),
      schoolId: json['schoolId'] as String? ?? '',
      subject: SubjectEnum.fromString(json['subject'] as String?),
      isMain: json['isMain'] as bool? ?? false,
      isHaveAttendance: json['isHaveAttendance'] as bool? ?? false,
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'teacherId': teacherId,
      'classId': classEntity.toJson(),
      'schoolId': schoolId,
      'subject': subject.name,
      'isMain': isMain,
      'isHaveAttendance': isHaveAttendance,
    };
  }

  ClassTeacherAssignEntity toEntity() {
    return ClassTeacherAssignEntity(
      id: id,
      teacherId: teacherId,
      classEntity: classEntity,
      schoolId: schoolId,
      subject: subject,
      isMain: isMain,
      isHaveAttendance: isHaveAttendance,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ClassTeacherAssignModel.fromEntity(ClassTeacherAssignEntity entity) {
    return ClassTeacherAssignModel(
      id: entity.id,
      teacherId: entity.teacherId,
      classEntity: entity.classEntity,
      schoolId: entity.schoolId,
      subject: entity.subject,
      isMain: entity.isMain,
      isHaveAttendance: entity.isHaveAttendance,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
