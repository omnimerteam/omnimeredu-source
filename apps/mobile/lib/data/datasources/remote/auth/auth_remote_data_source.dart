import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/constants/storage_constant.dart';
import '../../../../core/error/failures.dart';
import '../../../../domain/entities/auth/login_entity.dart';
import '../../../../services/secure_storage_service.dart';
import '../../../models/auth/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> login(LoginEntity params);
  Future<void> logout();
  Future<AuthUserModel?> getCurrentUser();
  Future<ApiResponse<void>> changePassword(
    String oldPassword,
    String newPassword,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;
  final SecureStorageService secureStorage;

  AuthRemoteDataSourceImpl(this.client, this.secureStorage);

  @override
  Future<AuthUserModel> login(LoginEntity params) async {
    try {
      final response = await client.post<Map<String, dynamic>>(
        Endpoints.user.login,
        data: {"email": params.email, "password": params.password},
        requiresAuth: false,
      );

      if (!response.success) {
        throw AuthFailure(response.message ?? "Đăng nhập thất bại");
      }

      final data = response.data;
      if (data == null) {
        throw const AuthFailure("Phản hồi từ server không có dữ liệu");
      }

      // Extract tokens
      String? accessToken = data['accessToken'];
      String? refreshToken = data['refreshToken'];

      // Extract User
      final userJson = data['user'];

      if (accessToken == null || refreshToken == null || userJson == null) {
        // Fallback checking if data IS the user/token wrapper directly
        // Sometimes data = { accessToken: "...", user: ... }
        // Just in case structure varies.
        throw const AuthFailure(
          "Cấu trúc phản hồi không hợp lệ (thiếu token hoặc user)",
        );
      }

      // Save tokens
      await secureStorage.update(StorageConstant.kAccessTokenKey, accessToken);
      await secureStorage.update(
        StorageConstant.kRefreshTokenKey,
        refreshToken,
      );

      // Return Model
      return AuthUserModel.fromJson(userJson);
    } catch (e) {
      if (e is Failure) rethrow;
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    // Gọi API logout nếu cần
    try {
      await client.post(Endpoints.user.logout);
    } catch (_) {
      // Ignored error on server logout
    }
    // Xóa token local
    await secureStorage.delete(StorageConstant.kAccessTokenKey);
    await secureStorage.delete(StorageConstant.kRefreshTokenKey);
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    try {
      final response = await client.get<Map<String, dynamic>>(
        Endpoints.user.profile,
      );

      if (!response.success) {
        // Token expired or invalid
        return null;
      }

      final data = response.data;
      // Depending on structure: sometimes response.data IS the user object, or wrapper { user: ... }
      // Profile endpoint usually returns the user object directly or inside 'data'.
      // ApiClient unwraps 'data' if success.
      // If valid data is Map:
      if (data != null) {
        // Check if it has 'user' key or is flat
        if (data.containsKey('user')) {
          return AuthUserModel.fromJson(data['user']);
        }
        // Assume flat
        return AuthUserModel.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResponse<void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final response = await client.post<Map<String, dynamic>>(
        Endpoints.user.changePassword,
        data: {"oldPassword": oldPassword, "newPassword": newPassword},
      );

      return ApiResponse<void>(
        success: response.success,
        message: response.message,
        data: null,
      );
    } catch (e) {
      return ApiResponse<void>.error(e.toString(), error: e);
    }
  }
}
