import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool loading;
  final String? error;
  final bool isLogin;

  const LoginState({this.loading = false, this.error, this.isLogin = false});

  LoginState copyWith({bool? loading, String? error, bool? isLogin}) {
    return LoginState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      isLogin: isLogin ?? this.isLogin,
    );
  }

  @override
  List<Object?> get props => [loading, error, isLogin];
}
