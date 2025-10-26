import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';

class AuthUserEntity extends Equatable {
  final String id;
  final String fullName;
  final String roleName;
  final bool? isVerified;
  final String? schoolId;
  final String? schoolName;
  final EducationSystemLevelsEnum? schoolLevel;
  final String? avatarUrl;
  // SchoolAdmin
  final SchoolAdminPositionEnum? position;
  // Teacher
  final TeacherQualificationEnum? qualification;
  final String? classId;
  // Student
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

  static const _noChange = Object();

  AuthUserEntity copyWith({
    Object? id = _noChange,
    Object? fullName = _noChange,
    Object? roleName = _noChange,
    Object? isVerified = _noChange,
    Object? schoolId = _noChange,
    Object? schoolName = _noChange,
    Object? schoolLevel = _noChange,
    Object? avatarUrl = _noChange,
    Object? position = _noChange,
    Object? qualification = _noChange,
    Object? classId = _noChange,
    Object? className = _noChange,
    Object? educationLevel = _noChange,
    Object? gradeGroup = _noChange,
  }) {
    return AuthUserEntity(
      id: id == _noChange ? this.id : id as String,
      fullName: fullName == _noChange ? this.fullName : fullName as String,
      roleName: roleName == _noChange ? this.roleName : roleName as String,
      isVerified: isVerified == _noChange
          ? this.isVerified
          : isVerified as bool?,
      schoolId: schoolId == _noChange ? this.schoolId : schoolName as String?,
      schoolName: schoolName == _noChange
          ? this.schoolName
          : schoolName as String?,
      schoolLevel: schoolLevel == _noChange
          ? this.schoolLevel
          : schoolLevel as EducationSystemLevelsEnum?,
      avatarUrl: avatarUrl == _noChange ? this.avatarUrl : avatarUrl as String?,
      position: position == _noChange
          ? this.position
          : position as SchoolAdminPositionEnum?,
      qualification: qualification == _noChange
          ? this.qualification
          : qualification as TeacherQualificationEnum?,
      classId: classId == _noChange ? this.classId : classId as String?,
      className: className == _noChange ? this.className : className as String?,
      educationLevel: educationLevel == _noChange
          ? this.educationLevel
          : educationLevel as EducationSystemLevelsEnum?,
      gradeGroup: gradeGroup == _noChange
          ? this.gradeGroup
          : gradeGroup as EducationGradesEnum?,
    );
  }

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
