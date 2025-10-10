import 'package:equatable/equatable.dart';

class BaseUserEntity extends Equatable {
  final String roleId;
  final String fullName;
  final String gender; // Male | Female | Other
  final String? phone;
  final DateTime? birthday;
  final String? address;
  final String? avatarUrl;

  const BaseUserEntity({
    required this.roleId,
    required this.fullName,
    required this.gender,
    this.phone,
    this.birthday,
    this.address,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [
    roleId,
    fullName,
    gender,
    phone,
    birthday,
    address,
    avatarUrl,
  ];
}
