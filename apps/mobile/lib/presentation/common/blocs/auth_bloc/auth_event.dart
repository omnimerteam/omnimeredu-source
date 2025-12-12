part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final LoginEntity loginEntity;

  const AuthLoginRequested(this.loginEntity);

  @override
  List<Object?> get props => [loginEntity];
}

class AuthLogoutRequested extends AuthEvent {}
