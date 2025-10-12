import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';

import 'base_user_entity.dart';
import 'registered_extra_fee_entity.dart';

class StudentEntity extends BaseUserEntity {
  final String? classId;
  final String? guardianName;
  final String? guardianPhone;
  final EducationSystemLevelsEnum educationLevel;
  final EducationGradesEnum? gradeGroup;
  final List<RegisteredExtraFeeEntity>? registeredExtraFees;
  final List<String>? registeredDiscounts;

  const StudentEntity({
    super.id,
    required super.fullName,
    super.roleId,
    super.email,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified = false,
    super.schoolId,
    super.avatarUrl,
    super.createdAt,
    super.updatedAt,
    this.classId,
    this.guardianName,
    this.guardianPhone,
    required this.educationLevel,
    this.gradeGroup,
    this.registeredExtraFees,
    this.registeredDiscounts,
  }) : super(roleKey: 'Student');

  /// copyWith override để tạo bản sao với trường cập nhật
  @override
  StudentEntity copyWith({
    String? id,
    String? fullName,
    String? roleId,
    String? email,
    String? gender,
    DateTime? birthday,
    String? phone,
    String? address,
    bool? isVerified,
    String? schoolId,
    String? avatarUrl,
    String? roleKey, // bắt buộc để match abstract
    DateTime? createdAt,
    DateTime? updatedAt,
    String? classId,
    String? guardianName,
    String? guardianPhone,
    EducationSystemLevelsEnum? educationLevel,
    EducationGradesEnum? gradeGroup,
    List<RegisteredExtraFeeEntity>? registeredExtraFees,
    List<String>? registeredDiscounts,
  }) {
    return StudentEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      roleId: roleId ?? this.roleId,
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
      classId: classId ?? this.classId,
      guardianName: guardianName ?? this.guardianName,
      guardianPhone: guardianPhone ?? this.guardianPhone,
      educationLevel: educationLevel ?? this.educationLevel,
      gradeGroup: gradeGroup ?? this.gradeGroup,
      registeredExtraFees: registeredExtraFees ?? this.registeredExtraFees,
      registeredDiscounts: registeredDiscounts ?? this.registeredDiscounts,
      // roleKey luôn cố định
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    classId,
    guardianName,
    guardianPhone,
    educationLevel,
    gradeGroup,
    registeredExtraFees,
    registeredDiscounts,
  ];
}
