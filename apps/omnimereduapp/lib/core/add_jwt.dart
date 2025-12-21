import 'package:firebase_auth/firebase_auth.dart';
import '../services/token_storage_service.dart';

/// Loại provider xác thực
enum AuthProviderType { firebase, jwt }

/// Interface cho các auth provider
/// Cho phép switch giữa Firebase Auth và JWT Auth
abstract class AppAuthProvider {
  /// Lấy token để gắn vào header Authorization
  Future<String?> getAuthToken();

  /// Đăng xuất
  Future<void> signOut();

  /// Kiểm tra đã xác thực chưa
  Future<bool> get isAuthenticated;

  /// Loại provider
  AuthProviderType get type;
}

/// Firebase Auth Provider
/// Sử dụng Firebase Authentication để lấy ID Token
class FirebaseAuthProvider implements AppAuthProvider {
  @override
  Future<String?> getAuthToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<bool> get isAuthenticated async {
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  AuthProviderType get type => AuthProviderType.firebase;
}

/// JWT Auth Provider
/// Sử dụng TokenStorageService để quản lý JWT tokens
class JwtAuthProvider implements AppAuthProvider {
  final TokenStorageService _tokenStorage;

  JwtAuthProvider(this._tokenStorage);

  @override
  Future<String?> getAuthToken() async {
    return await _tokenStorage.getAccessToken();
  }

  @override
  Future<void> signOut() async {
    await _tokenStorage.clearTokens();
  }

  @override
  Future<bool> get isAuthenticated async {
    return await _tokenStorage.hasValidToken();
  }

  @override
  AuthProviderType get type => AuthProviderType.jwt;
}

/// Factory tạo AppAuthProvider theo loại
class AuthProviderFactory {
  static AppAuthProvider create(
    AuthProviderType type, {
    TokenStorageService? tokenStorage,
  }) {
    switch (type) {
      case AuthProviderType.firebase:
        return FirebaseAuthProvider();
      case AuthProviderType.jwt:
        if (tokenStorage == null) {
          throw ArgumentError('TokenStorageService required for JWT provider');
        }
        return JwtAuthProvider(tokenStorage);
    }
  }
}
