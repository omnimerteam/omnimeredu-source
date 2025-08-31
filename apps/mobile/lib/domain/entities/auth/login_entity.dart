class LoginEntity {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginEntity({
    required this.email,
    required this.password,
    required this.rememberMe,
  });
}
