import '../../../core/constants/enum_constant.dart';
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

  /// copyWith override để khớp BaseUserEntity
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
    String? roleKey, // bắt buộc có tham số để khớp abstract
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
      // Bỏ qua roleKey truyền vào, luôn cố định 'SchoolAdmin'
    );
  }

  @override
  List<Object?> get props => [...super.props, position];
}
