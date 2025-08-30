import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user_entity.dart';

class LoginState extends Equatable {
  final bool loading;
  final String? error;
  final UserEntity? user;

  const LoginState({this.loading = false, this.error, this.user});

  LoginState copyWith({bool? loading, String? error, UserEntity? user}) {
    return LoginState(
      loading: loading ?? this.loading,
      error: error,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [loading, error ?? "", user ?? ""];
}
