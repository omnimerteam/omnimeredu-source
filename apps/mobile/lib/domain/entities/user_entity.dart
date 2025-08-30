import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String roleName;
  final String roleKey;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.roleName,
    required this.roleKey,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, fullName, roleName, roleKey, avatarUrl];
}
