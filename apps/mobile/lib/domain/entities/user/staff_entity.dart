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

  @override
  List<Object?> get props => [...super.props];
}
