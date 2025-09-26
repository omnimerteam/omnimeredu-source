part of 'role_bloc.dart';

abstract class RoleState {}

class RoleInitial extends RoleState {}

class RoleLoading extends RoleState {}

class RoleLoaded extends RoleState {
  final List<RoleEntity> roles;
  RoleLoaded(this.roles);
}

class RolePersonnelLoaded extends RoleState {
  final List<RoleEntity> roles;
  RolePersonnelLoaded(this.roles);
}

class RoleError extends RoleState {
  final String message;
  RoleError(this.message);
}
