import '../../../core/constants/enum_constant.dart';

import '../../../domain/entities/user/school_admin_entity.dart';
import '../../../domain/entities/user/user_role_enum.dart';
import 'base_user_model.dart';

class SchoolAdminModel extends BaseUserModel {
  final SchoolAdminPositionEnum? position;

  const SchoolAdminModel({
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
    super.createdAt,
    super.updatedAt,
    this.position,
  }) : super(roleKey: UserRole.SchoolAdmin);

  factory SchoolAdminModel.fromJson(Map<String, dynamic> json) {
    final base = BaseUserModel.fromJson(json, roleKey: 'SchoolAdmin');
    return SchoolAdminModel(
      id: base.id,
      fullName: base.fullName,
      roleId: base.roleId,
      email: base.email,
      gender: base.gender,
      birthday: base.birthday,
      phone: base.phone,
      address: base.address,
      isVerified: base.isVerified,
      schoolId: base.schoolId,
      avatarUrl: base.avatarUrl,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      position: json['position'] != null
          ? SchoolAdminPositionEnum.fromString(json['position'] as String)
          : null,
    );
  }

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
      createdAt: createdAt,
      updatedAt: updatedAt,
      position: position,
    );
  }
}
