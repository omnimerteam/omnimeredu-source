import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({
    required super.id,
    required super.fullName,
    required super.roleName,
    super.isVerified,
    super.avatarUrl,
    super.schoolId,
    super.schoolName,
    super.schoolLevel,
    super.position,
    super.qualification,
    super.classId,
    super.className,
    super.educationLevel,
    super.grade,
  });

  /// Chuyển từ JSON sang Model
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      roleName: json['roleId']?['name'] ?? '',
      isVerified: json['isVerified'] ?? false,
      avatarUrl: json['avatarUrl'] ?? '',
      schoolId: json['schoolId']?['_id'] ?? '',
      schoolName: json['schoolId']?['name'] ?? '',
      schoolLevel: EducationSystemLevelsEnum.fromString(
        json['schoolId']?['level'] as String?,
      ),
      position: json['position']?.toString() ?? '',
      qualification: json['qualification']?.toString() ?? '',
      classId: json['classId']?['_id'] ?? '',
      className: json['classId']?['name'] ?? '',
      educationLevel: EducationSystemLevelsEnum.fromString(
        json['eductionLevel'] as String?,
      ),
      grade: json['grade']?.toString() ?? '',
    );
  }

  /// Chuyển từ Model sang JSON
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
      'position': position,
      'qualification': qualification,
      'classId': classId,
      'className': className,
      'educationLevel': educationLevel?.name,
      'grade': grade,
    };
  }

  /// Chuyển Model về Entity (tách biệt domain)
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
      grade: grade,
    );
  }
}
