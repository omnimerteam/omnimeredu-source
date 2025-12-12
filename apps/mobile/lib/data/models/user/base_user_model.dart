import '../../../core/constants/app_constant.dart';
import '../../../domain/entities/user/base_user_entity.dart';

abstract class BaseUserModel {
  final String? id;
  final String fullName;
  final String? roleId;
  final String? email;
  final String? gender;
  final DateTime? birthday;
  final String? phone;
  final String? address;
  final bool isVerified;
  final String? schoolId;
  final String? avatarUrl;
  final String roleKey;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BaseUserModel({
    this.id,
    required this.fullName,
    this.roleId,
    this.email,
    this.gender,
    this.birthday,
    this.phone,
    this.address,
    this.isVerified = false,
    this.schoolId,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
    required this.roleKey,
  });

  factory BaseUserModel.fromJson(
    Map<String, dynamic> json, {
    required String roleKey,
  }) {
    return _BaseUserModelImpl(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String? ?? 'Unknown',
      roleId: json['roleId'] is Map ? json['roleId']['_id'] : json['roleId'],
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
      schoolId: json['schoolId'] is Map
          ? json['schoolId']['_id']
          : json['schoolId'],
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
      'email': email,
      'gender': gender,
      'birthday': birthday?.toUtc().toIso8601String(),
      'phone': phone,
      'address': address,
      'isVerified': isVerified,
      'schoolId': schoolId,
      'avatarUrl': avatarUrl,
      'roleKey': roleKey,
      'createdAt': createdAt?.toUtc().toIso8601String(),
      'updatedAt': updatedAt?.toUtc().toIso8601String(),
    };
  }

  BaseUserEntity toEntity();
}

class _BaseUserModelImpl extends BaseUserModel {
  const _BaseUserModelImpl({
    required super.id,
    required super.fullName,
    super.roleId,
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
    required super.roleKey,
  });

  @override
  BaseUserEntity toEntity() {
    // Basic entity for base model
    return BasicUserEntity(
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
      roleKey: roleKey,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class BasicUserEntity extends BaseUserEntity {
  const BasicUserEntity({
    super.id,
    required super.fullName,
    super.roleId,
    super.email,
    super.gender,
    super.birthday,
    super.phone,
    super.address,
    super.isVerified,
    super.schoolId,
    super.avatarUrl,
    required super.roleKey,
    super.createdAt,
    super.updatedAt,
  });
}
