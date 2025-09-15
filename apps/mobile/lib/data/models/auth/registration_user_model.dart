import 'package:flutter_ios_android_platforms/domain/entities/auth/register_user_entity.dart';

class RegisterUserModel extends RegisterUserEntity {
  const RegisterUserModel({
    required super.email,
    required super.password,
    required super.baseUserInfo,
    super.schoolId,
    super.classId,
    super.specificInfo,
    super.schoolData,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'email': email,
      'password': password,
      'schoolId': schoolId,
      'classId': classId,
      'baseUserInfo': {
        'roleId': baseUserInfo.roleId,
        'fullName': baseUserInfo.fullName,
        if (baseUserInfo.gender != null) 'gender': baseUserInfo.gender,
        if (baseUserInfo.phone != null) 'phone': baseUserInfo.phone,
        if (baseUserInfo.birthday != null)
          'birthday': baseUserInfo.birthday!.toUtc().toIso8601String(),
        if (baseUserInfo.address != null) 'address': baseUserInfo.address,
      },
    };

    if (specificInfo != null) {
      json['specificInfo'] = specificInfo;
    }

    if (schoolData != null) {
      json['schoolData'] = {
        'name': schoolData!.name,
        'address': schoolData!.address,
        'level': schoolData!.level,
        if (schoolData!.phone != null) 'phone': schoolData!.phone,
        if (schoolData!.description != null)
          'description': schoolData!.description,
      };
    }

    return json;
  }
}
