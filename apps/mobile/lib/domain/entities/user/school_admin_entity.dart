import '../../../core/constants/enum_constant.dart';
import 'base_user_entity.dart';
import 'user_role_enum.dart';

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
  }) : super(roleKey: UserRole.SchoolAdmin);

  @override
  SchoolAdminEntity copyWith({
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
    SchoolAdminPositionEnum? position,
  }) {
    return SchoolAdminEntity(
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
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [...super.props, position];
}
