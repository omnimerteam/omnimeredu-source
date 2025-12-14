import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../../../core/constants/enum_constant.dart';

class RegistrationState extends Equatable {
  final bool loading;
  final String? error;
  final bool success;

  // roles
  final RoleKeyEnum? selectedRole;

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
  final EducationSystemLevelsEnum? selectedEducationLevel;

  // student
  final String? guardianName;
  final String? guardianPhone;
  final EducationSystemLevelsEnum? educationLevel;
  final String? classId;
  final String? assignClassName;
  final EducationGradesEnum? gradeGroup;

  // teacher
  final TeacherQualificationEnum? qualification;
  final List<SubjectEnum>? subjects;

  // school admin
  final bool isCreateNewSchool;
  final SchoolAdminPositionEnum? position;
  final String? schoolName;
  final String? schoolAddress;
  final String? schoolPhone;
  final String? schoolDescription;
  final EducationSystemLevelsEnum? schoolLevel;
  final File? schoolLogoFile;

  factory RegistrationState.initial() {
    return const RegistrationState(
      loading: false,
      error: null,
      success: false,
      gender: "Male",
      isCreateNewSchool: false,
      selectedEducationLevel: EducationSystemLevelsEnum.Preschool,
    );
  }

  const RegistrationState({
    this.loading = false,
    this.error,
    this.success = false,
    this.selectedRole,
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
    this.selectedEducationLevel = EducationSystemLevelsEnum.Preschool,
    this.guardianName,
    this.guardianPhone,
    this.educationLevel,
    this.classId,
    this.assignClassName,
    this.gradeGroup,
    this.qualification,
    this.subjects,
    this.isCreateNewSchool = false,
    this.position = SchoolAdminPositionEnum.None,
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
    RoleKeyEnum? selectedRole,
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
    EducationSystemLevelsEnum? selectedEducationLevel,
    String? guardianName,
    String? guardianPhone,
    EducationSystemLevelsEnum? educationLevel,
    String? classId,
    String? assignClassName,
    EducationGradesEnum? gradeGroup,
    TeacherQualificationEnum? qualification,
    List<SubjectEnum>? subjects,
    bool? isCreateNewSchool,
    SchoolAdminPositionEnum? position,
    String? schoolName,
    String? schoolCode,
    String? schoolAddress,
    String? schoolPhone,
    String? schoolDescription,
    EducationSystemLevelsEnum? schoolLevel,
    File? schoolLogoFile,
  }) {
    return RegistrationState(
      loading: loading ?? this.loading,
      error: error,
      success: success ?? this.success,
      selectedRole: selectedRole ?? this.selectedRole,
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
      gradeGroup: gradeGroup ?? this.gradeGroup,
      qualification: qualification ?? this.qualification,
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
    selectedRole,
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
    gradeGroup,
    qualification,
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
