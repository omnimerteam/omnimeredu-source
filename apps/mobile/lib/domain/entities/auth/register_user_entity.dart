import '../../core/constants/enum_constant.dart';
import 'base_user_entity.dart';
import '../school/school_data_entity.dart';

class RegisterUserEntity {
  final String email;
  final String password;
  final String? schoolId;
  final String? classId;
  final BaseUserForRegisterEntity baseUserInfo;
  final Map<String, dynamic> specificInfo;
  final SchoolDataEntity? schoolData;

  RegisterUserEntity({
    required this.email,
    required this.password,
    this.schoolId,
    this.classId,
    required this.baseUserInfo,
    required this.specificInfo,
    this.schoolData,
  });
}

class BaseUserForRegisterEntity {
  final String roleId;
  final String fullName;
  final String gender;
  final String? phone;
  final DateTime? birthday;
  final String? address;
  final String? avatarUrl;
  final String? avatarPath;

  BaseUserForRegisterEntity({
    required this.roleId,
    required this.fullName,
    required this.gender,
    this.phone,
    this.birthday,
    this.address,
    this.avatarUrl,
    this.avatarPath,
  });
}