import 'package:flutter_ios_android_platforms/domain/entities/user/base_user_entity.dart';

class StaffEntity extends BaseUserEntity {
  const StaffEntity({
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
  }) : super(roleKey: 'Staff');

  /// copyWith override, roleKey cố định 'Staff'
  @override
  StaffEntity copyWith({
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
  }) {
    return StaffEntity(
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
      // roleKey luôn cố định
    );
  }

  @override
  List<Object?> get props => [...super.props];
}
