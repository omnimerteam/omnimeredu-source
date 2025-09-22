import 'base_user_entity.dart';

class SchoolAdminEntity extends BaseUserEntity {
  final String position;

  const SchoolAdminEntity({
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
    this.position = "Hiệu trưởng",
  }) : super(roleKey: 'SchoolAdmin');

  @override
  List<Object?> get props => [...super.props, position];
}
