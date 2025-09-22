import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/staff_entity.dart';
import 'package:flutter_ios_android_platforms/data/models/user/base_user_model.dart';

class StaffModel extends BaseUserModel {
  const StaffModel({
    required super.id,
    required super.fullName,
    required super.roleId,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified = false,
    super.schoolId,
    super.avatarUrl,
    super.createdAt,
    super.updatedAt,
  }) : super(roleKey: "Staff");

  /// Parse từ JSON
  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      roleId: json['roleId'] as String,
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
    );
  }

  /// Convert sang JSON
  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'roleKey': roleKey};
  }

  /// Convert sang Entity
  @override
  StaffEntity toEntity() {
    return StaffEntity(
      id: id,
      fullName: fullName,
      roleId: roleId,
      gender: gender,
      birthday: birthday,
      phone: phone,
      address: address,
      isVerified: isVerified,
      schoolId: schoolId,
      avatarUrl: avatarUrl,
    );
  }

  /// Convert từ Entity sang Model
  factory StaffModel.fromEntity(StaffEntity entity) {
    return StaffModel(
      id: entity.id,
      fullName: entity.fullName,
      roleId: entity.roleId,
      gender: entity.gender,
      birthday: entity.birthday,
      phone: entity.phone,
      address: entity.address,
      isVerified: entity.isVerified,
      schoolId: entity.schoolId,
      avatarUrl: entity.avatarUrl,
    );
  }
}
