# JWT Authentication Implementation Plan

> **Mục tiêu**: Triển khai JWT Auth cho Flutter app với auto refresh token và khả năng switch giữa Firebase/JWT.

---

## Phase 1: Core Infrastructure

### 1.1. Token Storage Service

📁 `lib/services/token_storage_service.dart`

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  static const _accessTokenKey = 'jwt_access_token';
  static const _refreshTokenKey = 'jwt_refresh_token';

  final FlutterSecureStorage _storage;

  TokenStorageService() : _storage = const FlutterSecureStorage();

  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
```

**Dependencies cần thêm vào `pubspec.yaml`:**

```yaml
dependencies:
  flutter_secure_storage: ^10.0.0
```

---

### 1.2. JWT API Client với Auto Refresh

📁 `lib/core/network/api_jwt.dart`

```dart
import 'package:dio/dio.dart';
import 'endpoints.dart';
import '../../services/token_storage_service.dart';

class JwtApiClient {
  final Dio dio;
  final TokenStorageService tokenStorage;
  bool _isRefreshing = false;

  JwtApiClient({required this.tokenStorage})
    : dio = Dio(BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      )) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Gắn access token vào header
        final token = await tokenStorage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Auto refresh khi nhận 401
        if (error.response?.statusCode == 401 && !_isRefreshing) {
          final success = await _refreshToken();
          if (success) {
            // Retry request với token mới
            final retryResponse = await _retryRequest(error.requestOptions);
            return handler.resolve(retryResponse);
          }
        }
        handler.next(error);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    _isRefreshing = true;
    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await Dio().post(
        '${Endpoints.baseUrl}${Endpoints.jwtRefreshToken}',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];
        await tokenStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
        return true;
      }
    } catch (_) {}

    // Refresh failed -> clear tokens (logout)
    await tokenStorage.clearTokens();
    _isRefreshing = false;
    return false;
  }

  Future<Response> _retryRequest(RequestOptions options) async {
    final token = await tokenStorage.getAccessToken();
    options.headers['Authorization'] = 'Bearer $token';
    return dio.fetch(options);
  }
}
```

---

### 1.3. Update Endpoints

📁 `lib/core/network/endpoints.dart` - Thêm:

```dart
// ================== AUTH JWT ==================
static const String jwtLogin = "/api/auth-jwt/login";
static const String jwtRegister = "/api/auth-jwt/register";
static const String jwtRefreshToken = "/api/auth-jwt/refresh-token";
static const String jwtChangePassword = "/api/auth-jwt/change-password";
static const String jwtForgetPassword = "/api/auth-jwt/forget-password";
static const String jwtLogout = "/api/auth-jwt/logout";
```

---

## Phase 2: JWT Auth Implementation

### 2.1. Auth Tokens Model

📁 `lib/data/models/auth/auth_tokens_model.dart`

```dart
import 'package:json_annotation/json_annotation.dart';
import 'auth_user_model.dart';

part 'auth_tokens_model.g.dart';

@JsonSerializable()
class AuthTokensModel {
  final String accessToken;
  final String refreshToken;
  final AuthUserModel? user;

  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
    this.user,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokensModelToJson(this);
}
```

---

### 2.2. Auth JWT Remote DataSource

📁 `lib/data/datasources/remote/auth/auth_jwt_remote_data_source.dart`

```dart
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../models/auth/auth_tokens_model.dart';
import '../../../models/auth/auth_user_model.dart';
import '../../../models/auth/registration_user_model.dart';

class AuthJwtRemoteDataSource {
  final ApiClient client; // Basic client (không kèm token)

  AuthJwtRemoteDataSource(this.client);

  /// Đăng nhập JWT
  Future<AuthTokensModel> login(String email, String password) async {
    final res = await client.post(
      Endpoints.jwtLogin,
      data: {'email': email, 'password': password},
    );

    if (!res.success || res.data == null) {
      throw Exception(res.message ?? 'Đăng nhập thất bại');
    }

    return AuthTokensModel.fromJson(res.data);
  }

  /// Đăng ký JWT
  Future<AuthTokensModel> register(RegisterUserModel user) async {
    final res = await client.post(
      Endpoints.jwtRegister,
      data: user.toJson(),
    );

    if (!res.success || res.data == null) {
      throw Exception(res.message ?? 'Đăng ký thất bại');
    }

    return AuthTokensModel.fromJson(res.data);
  }

  /// Refresh token
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    final res = await client.post(
      Endpoints.jwtRefreshToken,
      data: {'refreshToken': refreshToken},
    );

    if (!res.success || res.data == null) {
      throw Exception(res.message ?? 'Refresh token thất bại');
    }

    return AuthTokensModel.fromJson(res.data);
  }

  /// Đăng xuất
  Future<void> logout(String accessToken) async {
    await client.post(
      Endpoints.jwtLogout,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
  }

  /// Đổi mật khẩu
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String accessToken,
  }) async {
    final res = await client.patch(
      Endpoints.jwtChangePassword,
      headers: {'Authorization': 'Bearer $accessToken'},
      data: {'oldPassword': oldPassword, 'newPassword': newPassword},
    );

    if (!res.success) {
      throw Exception(res.message ?? 'Đổi mật khẩu thất bại');
    }
  }
}
```

---

## Phase 3: Auth Provider Strategy Pattern

### 3.1. Auth Provider Abstraction

📁 `lib/core/add_jwt.dart`

```dart
import 'package:firebase_auth/firebase_auth.dart';
import '../services/token_storage_service.dart';

/// Loại provider xác thực
enum AuthProviderType { firebase, jwt }

/// Interface cho các auth provider
abstract class AuthProvider {
  /// Lấy token để gắn vào header Authorization
  Future<String?> getAuthToken();

  /// Đăng xuất
  Future<void> signOut();

  /// Kiểm tra đã xác thực chưa
  Future<bool> get isAuthenticated;
}

/// Firebase Auth Provider
class FirebaseAuthProvider implements AuthProvider {
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
}

/// JWT Auth Provider
class JwtAuthProvider implements AuthProvider {
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
}

/// Factory tạo AuthProvider theo loại
class AuthProviderFactory {
  static AuthProvider create(
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
```

---

## Phase 4: Refactor Datasources

### 4.1. Base Remote DataSource

📁 `lib/data/datasources/remote/base_remote_data_source.dart`

```dart
import '../../../core/add_jwt.dart';
import '../../../core/network/api_client.dart';

/// Base class cho các remote data source
/// Sử dụng AuthProvider để lấy token thay vì hardcode Firebase
abstract class BaseRemoteDataSource {
  final ApiClient client;
  final AuthProvider authProvider;

  BaseRemoteDataSource(this.client, this.authProvider);

  /// Lấy headers với token
  Future<Map<String, String>> get authHeaders async {
    final token = await authProvider.getAuthToken();
    return token != null ? {'Authorization': 'Bearer $token'} : {};
  }
}
```

### 4.2. Refactor Pattern cho Datasources

**TRƯỚC (Hardcoded Firebase):**

```dart
class TeacherRemoteDataSource {
  final ApiClient client;

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  Future<ApiResponse<TeacherModel?>> updateTeacher(TeacherModel data) async {
    final token = await _getIdToken();
    // ...
  }
}
```

**SAU (Sử dụng AuthProvider):**

```dart
class TeacherRemoteDataSource extends BaseRemoteDataSource {
  TeacherRemoteDataSource(super.client, super.authProvider);

  Future<ApiResponse<TeacherModel?>> updateTeacher(TeacherModel data) async {
    final headers = await authHeaders;
    final res = await client.put<TeacherModel?>(
      Endpoints.teacherId(data.id!),
      headers: headers,
      data: data.toJson(),
      // ...
    );
    return res;
  }
}
```

### 4.3. Danh sách files cần refactor

| File                                                       | Trạng thái      |
| ---------------------------------------------------------- | --------------- |
| `auth/auth_remote_data_source.dart`                        | ⏳ Cần refactor |
| `dashboard/school_admin_dashboard_remote_data_source.dart` | ⏳ Cần refactor |
| `school/attendance/attendance_remote_data_source.dart`     | ⏳ Cần refactor |
| `school/membership_request_data_source.dart`               | ⏳ Cần refactor |
| `school/class/class_remote_data_source.dart`               | ⏳ Cần refactor |
| `school/school_remote_data_source.dart`                    | ⏳ Cần refactor |
| `school/grade_remote_data_source.dart`                     | ⏳ Cần refactor |
| `user/teacher_remote_data_source.dart`                     | ⏳ Cần refactor |
| `user/student_remote_data_source.dart`                     | ⏳ Cần refactor |
| `user/personnel_remote_data_source.dart`                   | ⏳ Cần refactor |
| `user/school_admin_remote_data_source.dart`                | ⏳ Cần refactor |

---

## Phase 5: Dependency Injection

### 5.1. Config cho Auth Provider Type

📁 `lib/core/config/auth_config.dart`

```dart
import '../add_jwt.dart';

class AuthConfig {
  /// Chuyển đổi giữa Firebase và JWT tại đây
  static const AuthProviderType currentProvider = AuthProviderType.jwt;

  /// Hoặc đọc từ environment
  static AuthProviderType get providerFromEnv {
    const String authType = String.fromEnvironment('AUTH_TYPE', defaultValue: 'firebase');
    return authType == 'jwt' ? AuthProviderType.jwt : AuthProviderType.firebase;
  }
}
```

### 5.2. Update DI Container

📁 `lib/injection_container.dart` - Thêm:

```dart
// Token Storage
sl.registerLazySingleton<TokenStorageService>(() => TokenStorageService());

// Auth Provider
sl.registerLazySingleton<AuthProvider>(() {
  return AuthProviderFactory.create(
    AuthConfig.currentProvider,
    tokenStorage: sl<TokenStorageService>(),
  );
});

// JWT Api Client (với auto refresh)
sl.registerLazySingleton<JwtApiClient>(() => JwtApiClient(
  tokenStorage: sl<TokenStorageService>(),
));

// Auth JWT DataSource
sl.registerLazySingleton<AuthJwtRemoteDataSource>(() =>
  AuthJwtRemoteDataSource(sl<ApiClient>()),
);

// Refactor các datasources để inject AuthProvider
sl.registerLazySingleton<TeacherRemoteDataSource>(() =>
  TeacherRemoteDataSource(sl<ApiClient>(), sl<AuthProvider>()),
);
// ... tương tự cho các datasources khác
```

---

## Checklist Triển Khai

| #   | Task                                            | Priority  |
| --- | ----------------------------------------------- | --------- |
| 1   | Thêm `flutter_secure_storage` vào pubspec.yaml  | 🔴 High   |
| 2   | Tạo `TokenStorageService`                       | 🔴 High   |
| 3   | Tạo `AuthTokensModel`                           | 🔴 High   |
| 4   | Implement `AuthJwtRemoteDataSource`             | 🔴 High   |
| 5   | Tạo `JwtApiClient` với auto refresh             | 🔴 High   |
| 6   | Tạo `AuthProvider` abstraction (`add_jwt.dart`) | 🔴 High   |
| 7   | Update Endpoints cho JWT                        | 🟡 Medium |
| 8   | Tạo `BaseRemoteDataSource`                      | 🟡 Medium |
| 9   | Refactor các datasources (11 files)             | 🟡 Medium |
| 10  | Tạo `AuthConfig`                                | 🟢 Low    |
| 11  | Update DI Container                             | 🟢 Low    |

---

## Kiến Trúc Tổng Quan

```
┌─────────────────────────────────────────────────────────────┐
│                      PRESENTATION                            │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                        DOMAIN                                │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                         DATA                                 │
│  ┌────────────────────────────────────────────────────────┐ │
│  │          RemoteDataSources (extends Base)              │ │
│  └───────────────────────┬────────────────────────────────┘ │
│                          │                                   │
│  ┌───────────────────────▼────────────────────────────────┐ │
│  │             AuthProvider (Strategy)                    │ │
│  │  ┌──────────────────┐  ┌─────────────────────────┐    │ │
│  │  │ FirebaseProvider │  │    JwtAuthProvider      │    │ │
│  │  └──────────────────┘  └───────────┬─────────────┘    │ │
│  │                                    │                   │ │
│  │                        ┌───────────▼─────────────┐    │ │
│  │                        │     JwtApiClient        │    │ │
│  │                        │  (Auto Refresh Token)   │    │ │
│  │                        └───────────┬─────────────┘    │ │
│  │                                    │                   │ │
│  │                        ┌───────────▼─────────────┐    │ │
│  │                        │  TokenStorageService    │    │ │
│  │                        └─────────────────────────┘    │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```
