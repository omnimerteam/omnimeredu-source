class BaseUserEntity {
  final String roleId;
  final String fullName;
  final String gender; // Male | Female | Other
  final String? phone;
  final DateTime? birthday;
  final String? address;
  final String? avatarUrl;

  BaseUserEntity({
    required this.roleId,
    required this.fullName,
    required this.gender,
    this.phone,
    this.birthday,
    this.address,
    this.avatarUrl,
  });
}
