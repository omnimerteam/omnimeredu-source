import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';

class ClassTeacherAssignEntity extends Equatable {
  final String? id;
  final String teacherId;
  final AssignedClassEntity classEntity;
  final String schoolId;
  final SubjectEnum subject;
  final bool isMain;
  final bool isHaveAttendance;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ClassTeacherAssignEntity({
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

  @override
  List<Object?> get props => [
    id,
    teacherId,
    classEntity,
    schoolId,
    subject,
    isMain,
    isHaveAttendance,
    createdAt,
    updatedAt,
  ];

  /// 🔹 Parse từ JSON (cache → entity)
  factory ClassTeacherAssignEntity.fromJson(Map<String, dynamic> json) {
    return ClassTeacherAssignEntity(
      id: json['_id'] as String?,
      teacherId: json['teacherId'] as String? ?? '',
      classEntity: AssignedClassEntity.fromJson(
        json['classId'] as Map<String, dynamic>,
      ),
      schoolId: json['schoolId'] as String? ?? '',
      subject: SubjectEnum.fromString(json['subject'] as String?),
      isMain: json['isMain'] as bool? ?? false,
      isHaveAttendance: json['isHaveAttendance'] as bool? ?? false,
      createdAt: (json['createdAt'] as String?) != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: (json['updatedAt'] as String?) != null
          ? DateTime.tryParse(json['updatedAt'] as String)
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ClassTeacherAssignEntity copyWith({
    String? id,
    String? teacherId,
    AssignedClassEntity? classEntity,
    String? schoolId,
    SubjectEnum? subject,
    bool? isMain,
    bool? isHaveAttendance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClassTeacherAssignEntity(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      classEntity: classEntity ?? this.classEntity,
      schoolId: schoolId ?? this.schoolId,
      subject: subject ?? this.subject,
      isMain: isMain ?? this.isMain,
      isHaveAttendance: isHaveAttendance ?? this.isHaveAttendance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AssignedClassEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final String schoolId;
  final String gradeId;
  final String gradeName;
  final int maxStudents;
  final int studentsCount;

  const AssignedClassEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.schoolId,
    required this.gradeId,
    required this.gradeName,
    required this.maxStudents,
    required this.studentsCount,
  });

  factory AssignedClassEntity.fromJson(Map<String, dynamic> json) {
    return AssignedClassEntity(
      id: json['_id'] as String,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      schoolId: json['schoolId'] as String? ?? '',
      gradeId:
          (json['gradeId'] as Map<String, dynamic>?)?['_id'] as String? ?? '',
      gradeName:
          (json['gradeId'] as Map<String, dynamic>?)?['name'] as String? ?? '',
      maxStudents: json['maxStudents'] as int? ?? 0,
      studentsCount: json['studentsCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'code': code,
      'schoolId': schoolId,
      'gradeId': {'_id': gradeId, 'name': gradeName},
      'maxStudents': maxStudents,
      'studentsCount': studentsCount,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    schoolId,
    gradeId,
    gradeName,
    maxStudents,
    studentsCount,
  ];
}
