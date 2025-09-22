import 'package:equatable/equatable.dart';

class BaseUserForRegisterEntity extends Equatable {
  final String? roleId;
  final String? fullName;
  final String? gender; // Male | Female | Other
  final String? phone;
  final DateTime? birthday;
  final String? address;
  final String? avatarUrl;

  const BaseUserForRegisterEntity({
    this.roleId,
    this.fullName,
    this.gender,
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
