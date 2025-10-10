import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/base_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/school_data.dart';

class RegisterUserEntity extends Equatable {
  final String email;
  final String password;
  final String? schoolId;
  final String? classId;
  final BaseUserEntity baseUserInfo;
  final Map<String, dynamic>? specificInfo;
  final SchoolDataEntity? schoolData;

  const RegisterUserEntity({
    required this.email,
    required this.password,
    required this.baseUserInfo,
    this.classId,
    this.schoolId,
    this.specificInfo,
    this.schoolData,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    schoolId,
    classId,
    baseUserInfo,
    specificInfo,
    schoolData,
  ];
}
