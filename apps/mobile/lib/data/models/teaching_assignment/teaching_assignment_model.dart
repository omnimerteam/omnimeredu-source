import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/teaching_assignment/teaching_assignment_entity.dart';

/// 🔹 Data Model cho TeachingAssignment
/// Trách nhiệm: ánh xạ JSON ↔ Entity
class TeachingAssignmentModel {
  final String? id;
  final String teacherId;
  final String classId;
  final String schoolId;
  final SubjectEnum? subject;
  final bool isMain;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TeachingAssignmentModel({
    this.id,
    required this.teacherId,
    required this.classId,
    required this.schoolId,
    this.subject,
    this.isMain = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Parse từ JSON → Model
  factory TeachingAssignmentModel.fromJson(Map<String, dynamic> json) {
    return TeachingAssignmentModel(
      id: json['_id'] as String?,
      teacherId: json['teacherId'] as String? ?? '',
      classId: json['classId'] as String? ?? '',
      schoolId: json['schoolId'] as String? ?? '',
      subject: SubjectEnum.fromString(json['subject'] as String?),
      isMain: json['isMain'] as bool? ?? false,
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

  /// Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'teacherId': teacherId,
      'classId': classId,
      'schoolId': schoolId,
      'subject': subject?.name,
      'isMain': isMain,
    };
  }

  /// Convert Model → Entity (Data → Domain)
  TeachingAssignmentEntity toEntity() {
    return TeachingAssignmentEntity(
      id: id,
      teacherId: teacherId,
      classId: classId,
      schoolId: schoolId,
      subject: subject,
      isMain: isMain,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert Entity → Model (Domain → Data)
  factory TeachingAssignmentModel.fromEntity(TeachingAssignmentEntity entity) {
    return TeachingAssignmentModel(
      id: entity.id,
      teacherId: entity.teacherId,
      classId: entity.classId,
      schoolId: entity.schoolId,
      subject: entity.subject,
      isMain: entity.isMain,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
