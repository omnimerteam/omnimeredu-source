import '../../../domain/entities/auth/login_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel({
    required super.email,
    required super.password,
    required super.rememberMe,
  });

  /// Chuyển từ JSON sang Model
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      rememberMe: json['rememberMe'] ?? false,
    );
  }

  /// Chuyển từ Model sang JSON
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'rememberMe': rememberMe};
  }
}
