import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/base_user_entity.dart';

abstract class BaseUserModel extends BaseUserEntity {
  const BaseUserModel({
    super.id,
    required super.fullName,
    super.roleId,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified = false,
    super.schoolId,
    super.avatarUrl,
    super.createdAt,
    super.updatedAt,
    required super.roleKey,
  });

  /// Parse từ JSON chung cho mọi user
  factory BaseUserModel.fromJson(
    Map<String, dynamic> json, {
    required String roleKey,
  }) {
    return _BaseUserModelImpl(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      roleId: json['roleId'] as String,
      gender: json['gender'] as String?,
      birthday: json['birthday'] != null
          ? AppConstants.toVietnamTime(
              DateTime.tryParse(json['createdAt'] as String),
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
      roleKey: roleKey,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'roleId': roleId,
      'gender': gender,
      'birthday': birthday?.toUtc().toIso8601String(),
      'phone': phone,
      'address': address,
      'isVerified': isVerified,
      'schoolId': schoolId,
      'avatarUrl': avatarUrl,
      'roleKey': roleKey,
    };
  }

  /// Mỗi model con (StudentModel, TeacherModel, …) sẽ override để trả về entity tương ứng
  BaseUserEntity toEntity();
}

/// Private implement để dùng cho factory chung
class _BaseUserModelImpl extends BaseUserModel {
  const _BaseUserModelImpl({
    required super.id,
    required super.fullName,
    required super.roleId,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified,
    super.schoolId,
    super.avatarUrl,
    super.createdAt,
    super.updatedAt,
    required super.roleKey,
  });

  @override
  BaseUserEntity toEntity() => this; // hoặc throw UnimplementedError nếu muốn buộc subclass override
}
