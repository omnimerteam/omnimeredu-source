import 'package:equatable/equatable.dart';

import 'user_role_enum.dart';

abstract class BaseUserEntity extends Equatable {
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
  final UserRole roleKey;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BaseUserEntity({
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

  @override
  List<Object?> get props => [
    id,
    fullName,
    roleId,
    email,
    gender,
    birthday,
    phone,
    address,
    isVerified,
    schoolId,
    avatarUrl,
    roleKey,
    createdAt,
    updatedAt,
  ];

  /// Abstract copyWith method to be implemented by subclasses
  BaseUserEntity copyWith({
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
    UserRole? roleKey,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}
