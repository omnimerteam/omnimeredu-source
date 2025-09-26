import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/school_admin_entity.dart';
import 'package:flutter_ios_android_platforms/data/models/user/base_user_model.dart';

class SchoolAdminModel extends BaseUserModel {
  final SchoolAdminPositionEnum? position;

  const SchoolAdminModel({
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
    this.position,
  }) : super(roleKey: 'SchoolAdmin');

  /// Parse từ JSON
  factory SchoolAdminModel.fromJson(Map<String, dynamic> json) {
    return SchoolAdminModel(
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
      position: SchoolAdminPositionEnum.fromString(json['position'] as String?),
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
    );
  }

  /// Convert sang JSON
  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'position': position};
  }

  /// Convert sang Entity
  @override
  SchoolAdminEntity toEntity() {
    return SchoolAdminEntity(
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
      position: position,
    );
  }

  /// Convert từ Entity sang Model
  factory SchoolAdminModel.fromEntity(SchoolAdminEntity entity) {
    return SchoolAdminModel(
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
      position: entity.position,
    );
  }
}
