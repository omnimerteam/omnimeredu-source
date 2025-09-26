import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'base_user_entity.dart';

class PersonnelEntity extends BaseUserEntity {
  final String roleName;

  // SchoolAdmin
  final SchoolAdminPositionEnum? position;
  // Teacher
  final TeacherQualificationEnum? qualification;
  final List<SubjectEnum>? subjects;

  const PersonnelEntity({
    super.id,
    required super.fullName,
    super.roleId,
    required super.roleKey,
    required this.roleName,
    super.email,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified,
    super.schoolId,
    super.avatarUrl,
    super.createdAt,
    super.updatedAt,
    this.qualification,
    this.subjects,
    this.position,
  });

  bool get isTeacher => roleKey == "Teacher";
  bool get isSchoolAdmin => roleKey == "SchoolAdmin";
  bool get isStaff => roleKey == "Staff";

  PersonnelEntity copyWith({
    String? id,
    String? fullName,
    String? roleId,
    String? roleKey,
    String? roleName,
    String? email,
    String? gender,
    DateTime? birthday,
    String? phone,
    String? address,
    bool? isVerified,
    String? schoolId,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    TeacherQualificationEnum? qualification,
    List<SubjectEnum>? subjects,
    SchoolAdminPositionEnum? position,
  }) {
    return PersonnelEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      roleId: roleId ?? this.roleId,
      roleKey: roleKey ?? this.roleKey,
      roleName: roleName ?? this.roleName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isVerified: isVerified ?? this.isVerified,
      schoolId: schoolId ?? this.schoolId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      qualification: qualification ?? this.qualification,
      subjects: subjects ?? this.subjects,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    roleKey,
    roleName,
    qualification,
    subjects,
    position,
  ];
}
