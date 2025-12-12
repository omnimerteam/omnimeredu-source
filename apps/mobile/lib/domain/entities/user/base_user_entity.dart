abstract class BaseUserEntity {
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
}
