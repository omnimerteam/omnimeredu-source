import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/role.dart';

class RegistrationState extends Equatable {
  final bool loading;
  final String? error;
  final bool success;

  // roles
  final List<RoleEntity> roles;
  final String? selectedRoleId;
  final String? selectedRoleName;

  // basic info
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? fullName;
  final String? gender;
  final DateTime? birthday;
  final String? phone;
  final String? address;
  final File? avatarFile;
  final String? schoolId;
  final String? assignSchoolName;

  // system
  final String? selectedEducationLevel;

  // student
  final String? guardianName;
  final String? guardianPhone;
  final String? educationLevel;
  final String? classId;
  final String? assignClassName;
  final String? grade;

  // teacher
  final String? literacy;
  final List<String>? subjects;

  // school admin
  final bool isCreateNewSchool;
  final String? position;
  final String? schoolName;
  final String? schoolAddress;
  final String? schoolPhone;
  final String? schoolDescription;
  final String? schoolLevel;
  final File? schoolLogoFile;

  const RegistrationState({
    this.loading = false,
    this.error,
    this.success = false,
    this.roles = const [],
    this.selectedRoleId,
    this.selectedRoleName,
    this.email,
    this.password,
    this.confirmPassword,
    this.fullName,
    this.gender = "Male",
    this.birthday,
    this.phone,
    this.address,
    this.avatarFile,
    this.schoolId,
    this.assignSchoolName,
    this.selectedEducationLevel,
    this.guardianName,
    this.guardianPhone,
    this.educationLevel,
    this.classId,
    this.assignClassName,
    this.grade,
    this.literacy,
    this.subjects,
    this.isCreateNewSchool = false,
    this.position,
    this.schoolName,
    this.schoolAddress,
    this.schoolPhone,
    this.schoolDescription,
    this.schoolLevel,
    this.schoolLogoFile,
  });

  RegistrationState copyWith({
    bool? loading,
    String? error,
    bool? success,
    List<RoleEntity>? roles,
    String? selectedRoleId,
    String? selectedRoleName,
    String? email,
    String? password,
    String? confirmPassword,
    String? fullName,
    String? gender,
    DateTime? birthday,
    String? phone,
    String? address,
    File? avatarFile,
    String? schoolId,
    String? assignSchoolName,
    String? selectedEducationLevel,
    String? guardianName,
    String? guardianPhone,
    String? educationLevel,
    String? classId,
    String? assignClassName,
    String? grade,
    String? literacy,
    List<String>? subjects,
    bool? isCreateNewSchool,
    String? position,
    String? schoolName,
    String? schoolCode,
    String? schoolAddress,
    String? schoolPhone,
    String? schoolDescription,
    String? schoolLevel,
    File? schoolLogoFile,
  }) {
    return RegistrationState(
      loading: loading ?? this.loading,
      error: error,
      success: success ?? this.success,
      roles: roles ?? this.roles,
      selectedRoleId: selectedRoleId ?? this.selectedRoleId,
      selectedRoleName: selectedRoleName ?? this.selectedRoleName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      avatarFile: avatarFile ?? this.avatarFile,
      schoolId: schoolId ?? this.schoolId,
      assignSchoolName: assignSchoolName ?? this.assignSchoolName,
      selectedEducationLevel:
          selectedEducationLevel ?? this.selectedEducationLevel,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      educationLevel: educationLevel ?? this.educationLevel,
      classId: classId ?? this.classId,
      assignClassName: assignClassName ?? this.assignClassName,
      grade: grade ?? this.grade,
      literacy: literacy ?? this.literacy,
      subjects: subjects ?? this.subjects,
      isCreateNewSchool: isCreateNewSchool ?? this.isCreateNewSchool,
      position: position ?? this.position,
      schoolName: schoolName ?? this.schoolName,
      schoolAddress: schoolAddress ?? this.schoolAddress,
      schoolPhone: schoolPhone ?? this.schoolPhone,
      schoolDescription: schoolDescription ?? this.schoolDescription,
      schoolLevel: schoolLevel ?? this.schoolLevel,
      schoolLogoFile: schoolLogoFile ?? this.schoolLogoFile,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    error,
    success,
    roles,
    selectedRoleId,
    selectedRoleName,
    email,
    password,
    confirmPassword,
    fullName,
    gender,
    birthday,
    phone,
    address,
    avatarFile,
    schoolId,
    assignSchoolName,
    selectedEducationLevel,
    guardianName,
    guardianPhone,
    educationLevel,
    classId,
    assignClassName,
    grade,
    literacy,
    subjects,
    isCreateNewSchool,
    position,
    schoolName,
    schoolAddress,
    schoolPhone,
    schoolDescription,
    schoolLevel,
    schoolLogoFile,
  ];
}
