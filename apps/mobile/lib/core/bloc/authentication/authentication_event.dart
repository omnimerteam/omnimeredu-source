// lib/application/auth/authentication_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';

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
