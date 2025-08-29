import '../../domain/entities/base_user.dart';

class BaseUserModel {
  final String roleId;
  final String fullName;
  final String gender;
  final String? phone;
  final DateTime? birthday;
  final String? address;
  final String? avatarUrl;

  BaseUserModel({
    required this.roleId,
    required this.fullName,
    required this.gender,
    this.phone,
    this.birthday,
    this.address,
    this.avatarUrl,
  });

  factory BaseUserModel.fromEntity(BaseUserEntity e) => BaseUserModel(
    roleId: e.roleId,
    fullName: e.fullName,
    gender: e.gender,
    phone: e.phone,
    birthday: e.birthday,
    address: e.address,
    avatarUrl: e.avatarUrl,
  );

  Map<String, dynamic> toJson() => {
    'roleId': roleId,
    'fullName': fullName,
    'gender': gender,
    if (phone != null) 'phone': phone,
    if (birthday != null) 'birthday': birthday!.toIso8601String(),
    if (address != null) 'address': address,
    if (avatarUrl != null) 'avatarUrl': avatarUrl,
  };
}
