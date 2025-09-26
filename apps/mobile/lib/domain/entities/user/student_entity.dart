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
