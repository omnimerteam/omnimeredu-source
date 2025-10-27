import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth/auth_user_entity.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationUnknown extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final AuthUserEntity user;

  const AuthenticationAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  final String message;

  const AuthenticationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
