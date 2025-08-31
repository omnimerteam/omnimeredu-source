import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({
    required super.id,
    required super.fullName,
    required super.roleName,
    super.isVerified,
    super.avatarUrl,
    super.schoolName,
    super.position,
    super.literacy,
    super.className,
    super.educationLevel,
    super.grade,
  });

  /// Chuyển từ JSON sang Model
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      roleName: json['roleId']['name'] ?? '',
      isVerified: json['isVerified'],
      avatarUrl: json['avatarUrl'],
      schoolName: json['schoolId']?['name'],
      position: json['position'],
      literacy: json['literacy'],
      className: json['classId']?['name'],
      educationLevel: json['educationLevel'],
      grade: json['grade'],
    );
  }

  /// Chuyển từ Model sang JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'roleName': roleName,
      'isVerified': isVerified,
      'schoolName': schoolName,
      'avatarUrl': avatarUrl,
      'position': position,
      'literacy': literacy,
      'className': className,
      'educationLevel': educationLevel,
      'grade': grade,
    };
  }
}
