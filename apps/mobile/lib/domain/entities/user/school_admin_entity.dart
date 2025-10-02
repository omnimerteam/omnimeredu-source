import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';

import 'base_user_entity.dart';

class SchoolAdminEntity extends BaseUserEntity {
  final SchoolAdminPositionEnum? position;

  const SchoolAdminEntity({
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
    this.position,
  }) : super(roleKey: 'SchoolAdmin');

  @override
  List<Object?> get props => [...super.props, position];
}
