import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/data/models/user/registered_extra_fee_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_entity.dart';
import 'package:flutter_ios_android_platforms/data/models/user/base_user_model.dart';

class StudentModel extends BaseUserModel {
  final String? classId;
  final String? guardianName;
  final String? guardianPhone;
  final EducationSystemLevelsEnum educationLevel;
  final EducationGradesEnum? gradeGroup;
  final List<RegisteredExtraFeeModel>? registeredExtraFees;
  final List<String>? registeredDiscounts;

  const StudentModel({
    required super.id,
    required super.fullName,
    required super.roleId,
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

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      roleId: json['roleId'] as String,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      birthday: json['birthday'] != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['birthday'] as String),
            )
          : null,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      schoolId: json['schoolId'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['createdAt'] as String),
            )
          : null,
      updatedAt: json['updatedAt'] != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['updatedAt'] as String),
            )
          : null,
      classId: json['classId'] as String?,
      guardianName: json['guardianName'] as String?,
      guardianPhone: json['guardianPhone'] as String?,
      educationLevel: EducationSystemLevelsEnum.fromString(
        json['educationLevel'] as String,
      ),
      gradeGroup: EducationGradesEnum.fromString(json['gradeGroup'] as String?),
      registeredExtraFees: (json['registeredExtraFees'] as List<dynamic>?)
          ?.map((e) => RegisteredExtraFeeModel.fromJson(e))
          .toList(),
      registeredDiscounts: (json['registeredDiscounts'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'classId': classId,
      'guardianName': guardianName,
      'guardianPhone': guardianPhone,
      'educationLevel': educationLevel.name,
      'gradeGroup': gradeGroup?.name,
      'registeredExtraFees': registeredExtraFees
          ?.map((e) => e.toJson())
          .toList(),
      'registeredDiscounts': registeredDiscounts,
    };
  }

  @override
  StudentEntity toEntity() {
    return StudentEntity(
      id: id,
      fullName: fullName,
      roleId: roleId,
      email: email,
      gender: gender,
      birthday: birthday,
      phone: phone,
      address: address,
      isVerified: isVerified,
      schoolId: schoolId,
      avatarUrl: avatarUrl,
      classId: classId,
      guardianName: guardianName,
      guardianPhone: guardianPhone,
      educationLevel: educationLevel,
      gradeGroup: gradeGroup,
      registeredExtraFees: registeredExtraFees,
      registeredDiscounts: registeredDiscounts,
    );
  }

  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      id: entity.id,
      fullName: entity.fullName,
      roleId: entity.roleId,
      email: entity.email,
      gender: entity.gender,
      birthday: entity.birthday,
      phone: entity.phone,
      address: entity.address,
      isVerified: entity.isVerified,
      schoolId: entity.schoolId,
      avatarUrl: entity.avatarUrl,
      classId: entity.classId,
      guardianName: entity.guardianName,
      guardianPhone: entity.guardianPhone,
      educationLevel: entity.educationLevel,
      gradeGroup: entity.gradeGroup,
      registeredExtraFees: entity.registeredExtraFees
          ?.map((e) => RegisteredExtraFeeModel.fromEntity(e))
          .toList(),
      registeredDiscounts: entity.registeredDiscounts,
    );
  }
}
