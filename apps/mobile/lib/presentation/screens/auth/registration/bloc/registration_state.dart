import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/role.dart';

class RegistrationState extends Equatable {
  final String email;
  final String password;
  final String roleId;
  final String fullName;
  final String gender;
  final String? phone;
  final DateTime? birthday;
  final String? address;
  final String? schoolId;
  final String? classId;
  final Map<String, dynamic> specificInfo;

  final File? avatarFile;
  final File? schoolLogoFile;

  final bool loading;
  final String? error;
  final bool success;

  final List<RoleEntity> roles;

  const RegistrationState({
    this.email = '',
    this.password = '',
    this.roleId = '',
    this.fullName = '',
    this.gender = 'Male',
    this.phone,
    this.birthday,
    this.address,
    this.schoolId,
    this.classId,
    this.specificInfo = const {},
    this.avatarFile,
    this.schoolLogoFile,
    this.loading = false,
    this.error,
    this.success = false,
    this.roles = const [],
  });

  RegistrationState copyWith({
    String? email,
    String? password,
    String? roleId,
    String? fullName,
    String? gender,
    String? phone,
    DateTime? birthday,
    String? address,
    String? schoolId,
    String? classId,
    Map<String, dynamic>? specificInfo,
    File? avatarFile,
    File? schoolLogoFile,
    bool? loading,
    String? error,
    bool? success,
    List<RoleEntity>? roles,
    bool clearError = false,
  }) => RegistrationState(
    email: email ?? this.email,
    password: password ?? this.password,
    roleId: roleId ?? this.roleId,
    fullName: fullName ?? this.fullName,
    gender: gender ?? this.gender,
    phone: phone ?? this.phone,
    birthday: birthday ?? this.birthday,
    address: address ?? this.address,
    schoolId: schoolId ?? this.schoolId,
    classId: classId ?? this.classId,
    specificInfo: specificInfo ?? this.specificInfo,
    avatarFile: avatarFile ?? this.avatarFile,
    schoolLogoFile: schoolLogoFile ?? this.schoolLogoFile,
    loading: loading ?? this.loading,
    error: clearError ? null : (error ?? this.error),
    success: success ?? this.success,
  );

  @override
  List<Object?> get props => [
    email,
    password,
    roleId,
    fullName,
    gender,
    phone,
    birthday,
    address,
    schoolId,
    classId,
    specificInfo,
    avatarFile?.path,
    schoolLogoFile?.path,
    loading,
    error,
    success,
    roles,
  ];
}
