import 'dart:io';

import 'package:equatable/equatable.dart';

import 'package:mobile/domain/entities/school/school_data_entity.dart';

class RegisterUserEntity extends Equatable {
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

class BaseUserForRegisterEntity {
  final String roleName; // Changed from roleId to roleName
  final String fullName;
  final String gender;
  final String? phone;
  final DateTime? birthday;
  final String? address;
  final File? avatar;

  BaseUserForRegisterEntity({
    required this.roleName, // Changed from roleId to roleName
    required this.fullName,
    required this.gender,
    this.phone,
    this.birthday,
    this.address,
    this.avatar,
  });
}
