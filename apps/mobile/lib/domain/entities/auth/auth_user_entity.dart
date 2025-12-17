import 'package:equatable/equatable.dart';

import '../../../core/constants/enum_constant.dart';

class AuthUserEntity extends Equatable {
  final String id;
  final String fullName;
  final String roleName;
  final bool? isVerified;
  final String? schoolId;
  final String? schoolName;
  final EducationSystemLevelsEnum? schoolLevel;
  final String? avatarUrl;
  final SchoolAdminPositionEnum? position;
  final TeacherQualificationEnum? qualification;
  final String? classId;
  final String? className;
  final EducationSystemLevelsEnum? educationLevel;
  final EducationGradesEnum? gradeGroup;

  const AuthUserEntity({
    required this.id,
    required this.fullName,
    required this.roleName,
    this.isVerified,
    this.schoolId,
    this.schoolName,
    this.schoolLevel,
    this.avatarUrl,
    this.position,
    this.qualification,
    this.classId,
    this.className,
    this.educationLevel,
    this.gradeGroup,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    roleName,
    isVerified,
    schoolId,
    schoolName,
    schoolLevel,
    avatarUrl,
    position,
    qualification,
    classId,
    className,
    educationLevel,
    gradeGroup,
  ];
}
