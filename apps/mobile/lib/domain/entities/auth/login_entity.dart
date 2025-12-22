import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginEntity({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}
