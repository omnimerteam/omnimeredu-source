import 'package:equatable/equatable.dart';
import '../../../core/constants/enum_constant.dart';

class TeachingAssignmentEntity extends Equatable {
  final String? id;
  final String teacherId;
  final String classId;
  final String schoolId;
  final SubjectEnum? subject;
  final bool isMain;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TeachingAssignmentEntity({
    this.id,
    required this.teacherId,
    required this.classId,
    required this.schoolId,
    this.subject,
    this.isMain = false,
    this.createdAt,
    this.updatedAt,
  });

  TeachingAssignmentEntity copyWith({
    String? id,
    String? teacherId,
    String? classId,
    String? schoolId,
    SubjectEnum? subject,
    bool? isMain,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TeachingAssignmentEntity(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      classId: classId ?? this.classId,
      schoolId: schoolId ?? this.schoolId,
      subject: subject ?? this.subject,
      isMain: isMain ?? this.isMain,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    teacherId,
    classId,
    schoolId,
    subject,
    isMain,
    createdAt,
    updatedAt,
  ];
}
