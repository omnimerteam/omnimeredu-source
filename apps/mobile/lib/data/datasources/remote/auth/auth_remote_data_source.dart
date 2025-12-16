import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/constants/storage_constant.dart';
import '../../../../core/error/failures.dart';
import '../../../../domain/entities/auth/login_entity.dart';
import '../../../../domain/entities/auth/register_user_entity.dart';
import '../../../../services/secure_storage_service.dart';
import '../../../models/auth/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> login(LoginEntity params);
  Future<void> logout();
  Future<AuthUserModel?> getCurrentUser();
  Future<AuthUserModel> registerUser(RegisterUserEntity user);
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
        throw AuthFailure(response.message);
      }

      final data = response.data;
      if (data == null) {
        throw const AuthFailure("Phản hồi từ server không có dữ liệu");
      }

      // Extract tokens from tokens object
      final tokensJson = data['tokens'];
      String? accessToken = tokensJson?['accessToken'];
      String? refreshToken = tokensJson?['refreshToken'];

      // Extract User
      final userJson = data['user'];

      if (accessToken == null || refreshToken == null || userJson == null) {
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
      // Backend currently does not have a logout endpoint
      // await client.post(Endpoints.user.logout);
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
        Endpoints.user.me,
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

  // ... registerUser ...

  Future<ApiResponse<void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      // Backend currently does not have a changePassword endpoint
      // final response = await client.post<Map<String, dynamic>>(
      //   Endpoints.user.changePassword,
      //   data: {"oldPassword": oldPassword, "newPassword": newPassword},
      // );
      throw UnimplementedError("Change password not implemented in backend");

      // return ApiResponse<void>(
      //   success: response.success,
      //   message: response.message,
      //   data: null,
      // );
    } catch (e) {
      return ApiResponse<void>.error(e.toString(), error: e);
    }
  }

  @override
  Future<AuthUserModel> registerUser(RegisterUserEntity user) async {
    try {
      // Create multipart request for file upload
      final Map<String, dynamic> data = {
        'email': user.email,
        'password': user.password,
        'roleName': user.baseUserInfo.roleName,
        'baseUserInfo': {
          'fullName': user.baseUserInfo.fullName,
          'gender': user.baseUserInfo.gender,
          'phone': user.baseUserInfo.phone,
          'birthday': user.baseUserInfo.birthday?.toIso8601String(),
          'address': user.baseUserInfo.address,
        },
        'specificInfo': user.specificInfo,
      };

      // Add schoolId and classId if they exist
      if (user.schoolId != null) {
        data['schoolId'] = user.schoolId;
      }
      if (user.classId != null) {
        data['classId'] = user.classId;
      }

      // Add schoolData if it exists (for SchoolAdmin creating new school)
      if (user.schoolData != null) {
        data['schoolData'] = {
          'name': user.schoolData!.name,
          'address': user.schoolData!.address,
          'phone': user.schoolData!.phone,
          'description': user.schoolData!.description,
          'level': user.schoolData!.level?.name,
        };
      }

      // Create the request
      final response = await client.post<Map<String, dynamic>>(
        Endpoints.user.register,
        data: data,
        requiresAuth: false,
        // Add file if avatar exists
        files: user.baseUserInfo.avatar != null
            ? {'avatar': user.baseUserInfo.avatar!}
            : null,
      );

      if (!response.success) {
        throw AuthFailure(response.message);
      }

      final responseData = response.data;
      if (responseData == null) {
        throw const AuthFailure("Phản hồi từ server không có dữ liệu");
      }

      // Extract tokens from tokens object
      final tokensJson = responseData['tokens'];
      String? accessToken = tokensJson?['accessToken'];
      String? refreshToken = tokensJson?['refreshToken'];

      // Extract User
      final userJson = responseData['user'];

      if (accessToken == null || refreshToken == null || userJson == null) {
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
}
