// States
import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/role.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RolesLoading extends RegistrationState {}

class RolesLoaded extends RegistrationState {
  final List<RoleEntity> roles;

  const RolesLoaded(this.roles);

  @override
  List<Object?> get props => [roles];
}

class RolesLoadError extends RegistrationState {
  final String message;

  const RolesLoadError(this.message);

  @override
  List<Object?> get props => [message];
}

class RegistrationSuccess extends RegistrationState {}

class RegistrationError extends RegistrationState {
  final String message;

  const RegistrationError(this.message);

  @override
  List<Object?> get props => [message];
}

class SchoolSearchLoading extends RegistrationState {}

class SchoolSearchSuccess extends RegistrationState {
  final Map<String, dynamic> schoolInfo;

  const SchoolSearchSuccess(this.schoolInfo);

  @override
  List<Object?> get props => [schoolInfo];
}

class SchoolSearchError extends RegistrationState {
  final String message;

  const SchoolSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
