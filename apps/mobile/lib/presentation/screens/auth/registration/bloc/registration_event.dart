import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
  @override
  List<Object?> get props => [];
}

/// load roles từ API
class LoadRolesEvent extends RegistrationEvent {}

/// update thông tin cơ bản
class UpdateBasicInfoEvent extends RegistrationEvent {
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? fullName;
  final String? gender;
  final DateTime? birthday;
  final String? phone;
  final String? address;
  final File? avatarFile;
  const UpdateBasicInfoEvent({
    this.email,
    this.password,
    this.confirmPassword,
    this.fullName,
    this.gender,
    this.birthday,
    this.phone,
    this.address,
    this.avatarFile,
  });
}

/// update role
class UpdateRoleEvent extends RegistrationEvent {
  final String roleId;
  final String? roleName;
  const UpdateRoleEvent(this.roleId, this.roleName);
  @override
  List<Object?> get props => [roleId, roleName];
}

/// update thông tin học sinh
class UpdateStudentInfoEvent extends RegistrationEvent {
  final String? guardianName;
  final String? guardianPhone;
  final String? educationLevel;
  final String? classId;
  final String? grade;
  const UpdateStudentInfoEvent({
    this.guardianName,
    this.guardianPhone,
    this.educationLevel,
    this.classId,
    this.grade,
  });
}

/// update thông tin giáo viên
class UpdateTeacherInfoEvent extends RegistrationEvent {
  final String? qualification;
  final List<String>? subjects;
  const UpdateTeacherInfoEvent({this.qualification, this.subjects});
}

/// update thông tin school admin
class UpdateSchoolAdminInfoEvent extends RegistrationEvent {
  final bool? isCreateNewSchool;
  final String? position;
  final String? schoolName;
  final String? schoolAddress;
  final String? schoolPhone;
  final String? schoolDescription;
  final String? schoolLevel;
  final File? schoolLogoFile;
  const UpdateSchoolAdminInfoEvent({
    this.isCreateNewSchool,
    this.position,
    this.schoolName,
    this.schoolAddress,
    this.schoolPhone,
    this.schoolDescription,
    this.schoolLevel,
    this.schoolLogoFile,
  });
}

/// cuối cùng: submit registration
class SubmitRegistrationEvent extends RegistrationEvent {}

class UpdateSchoolIdEvent extends RegistrationEvent {
  final String? schoolId;
  final String? assignSchoolName;
  const UpdateSchoolIdEvent({this.schoolId, this.assignSchoolName});
}

class UpdateClassIdEvent extends RegistrationEvent {
  final String? classId;
  final String? assignClassName;
  const UpdateClassIdEvent({this.classId, this.assignClassName});
}

class UpdateSelectedEducationLevelEvent extends RegistrationEvent {
  final String? selectedEducationLevel;
  const UpdateSelectedEducationLevelEvent({this.selectedEducationLevel});
}

class ResetRegistration extends RegistrationEvent {}
