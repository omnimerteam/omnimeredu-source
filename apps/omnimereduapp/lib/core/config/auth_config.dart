import '../add_jwt.dart';

/// Cấu hình cho Auth Provider
class AuthConfig {
  /// Chuyển đổi giữa Firebase và JWT tại đây
  /// Đổi sang AuthProviderType.firebase nếu muốn dùng Firebase Auth
  static const AuthProviderType currentProvider = AuthProviderType.jwt;

  /// Hoặc đọc từ environment variable
  /// Chạy với: flutter run --dart-define=AUTH_TYPE=jwt
  static AuthProviderType get providerFromEnv {
    const String authType = String.fromEnvironment(
      'AUTH_TYPE',
      defaultValue: 'firebase',
    );
    return authType == 'jwt' ? AuthProviderType.jwt : AuthProviderType.firebase;
  }

  /// Kiểm tra có đang dùng JWT không
  static bool get isUsingJwt => currentProvider == AuthProviderType.jwt;

  /// Kiểm tra có đang dùng Firebase không
  static bool get isUsingFirebase =>
      currentProvider == AuthProviderType.firebase;
}
