import '../../../core/constants/enum_constant.dart';
import '../../../domain/entities/auth/auth_user_entity.dart';

class AuthUserModel {
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

  const AuthUserModel({
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

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      roleName: json['roleId'] is Map
          ? json['roleId']['name']
          : (json['roleName'] ?? ''),
      isVerified: json['isVerified'] ?? false,
      avatarUrl: json['avatarUrl'] ?? '',
      schoolId: json['schoolId'] is Map
          ? json['schoolId']['_id']
          : json['schoolId'],
      schoolName: json['schoolId'] is Map ? json['schoolId']['name'] : null,
      schoolLevel: EducationSystemLevelsEnum.fromString(
        json['schoolId'] is Map ? json['schoolId']['level'] : null,
      ),
      position: SchoolAdminPositionEnum.fromString(json['position'] as String?),
      qualification: TeacherQualificationEnum.fromString(
        json['qualification'] as String?,
      ),
      classId: json['classId'] is Map
          ? json['classId']['_id']
          : json['classId'],
      className: json['classId'] is Map ? json['classId']['name'] : null,
      educationLevel: EducationSystemLevelsEnum.fromString(
        json['educationLevel'] as String?,
      ),
      gradeGroup: EducationGradesEnum.fromString(json['gradeGroup'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'roleName': roleName,
      'isVerified': isVerified,
      'schoolId': schoolId,
      'schoolName': schoolName,
      'schoolLevel': schoolLevel?.name,
      'avatarUrl': avatarUrl,
      'position': position?.name,
      'qualification': qualification?.name,
      'classId': classId,
      'className': className,
      'educationLevel': educationLevel?.name,
      'gradeGroup': gradeGroup?.name,
    };
  }

  AuthUserEntity toEntity() {
    return AuthUserEntity(
      id: id,
      fullName: fullName,
      roleName: roleName,
      isVerified: isVerified,
      avatarUrl: avatarUrl,
      schoolId: schoolId,
      schoolName: schoolName,
      schoolLevel: schoolLevel,
      position: position,
      qualification: qualification,
      classId: classId,
      className: className,
      educationLevel: educationLevel,
      gradeGroup: gradeGroup,
    );
  }
}
