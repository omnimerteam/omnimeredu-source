// lib/application/auth/authentication_event.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth/auth_user_entity.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {
  final AuthUserEntity user;

  const AuthenticationLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthenticationLoggedOut extends AuthenticationEvent {}

class AuthenticationSchoolUpdated extends AuthenticationEvent {
  final String? schoolName;

  const AuthenticationSchoolUpdated({this.schoolName});

  @override
  List<Object?> get props => [schoolName];
}

class UpdateUserAvatarEvent extends AuthenticationEvent {
  final String avatarUrl;
  UpdateUserAvatarEvent(this.avatarUrl);
}

class UpdateUserProfileEvent extends AuthenticationEvent {
  final AuthUserEntity updatedUser;
  const UpdateUserProfileEvent(this.updatedUser);

  @override
  List<Object?> get props => [updatedUser];
}
