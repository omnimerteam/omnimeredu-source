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

  /// Parse từ JSON (API -> Model)
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      roleName: json['roleId']?['name'] ?? '',
      isVerified: json['isVerified'] ?? false,
      avatarUrl: json['avatarUrl'] ?? '',
      schoolId: json['schoolId']?['_id'],
      schoolName: json['schoolId']?['name'],
      schoolLevel: EducationSystemLevelsEnum.fromString(
        json['schoolId']?['level'] as String?,
      ),
      position: SchoolAdminPositionEnum.fromString(json['position'] as String?),
      qualification: TeacherQualificationEnum.fromString(
        json['qualification'] as String?,
      ),
      classId: json['classId']?['_id'],
      className: json['classId']?['name'],
      educationLevel: EducationSystemLevelsEnum.fromString(
        json['educationLevel'] as String?, // sửa typo eduction -> education
      ),
      gradeGroup: EducationGradesEnum.fromString(json['gradeGroup'] as String?),
    );
  }

  /// Convert sang JSON (Model -> API)
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

  /// Convert Model -> Entity (Data -> Domain)
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
