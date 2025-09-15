import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';

class LoginState extends Equatable {
  final bool loading;
  final String? error;
  final AuthUserEntity? user;

  const LoginState({this.loading = false, this.error, this.user});

  LoginState copyWith({bool? loading, String? error, AuthUserEntity? user}) {
    return LoginState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [loading, error, user];
}
