import 'base_user_entity.dart';

class StudentEntity extends BaseUserEntity {
  const StudentEntity({
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
