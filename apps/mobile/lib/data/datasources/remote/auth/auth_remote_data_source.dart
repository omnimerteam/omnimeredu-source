import 'package:flutter_ios_android_platforms/core/error/failures.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/data/models/auth/auth_user_model.dart';
import 'package:flutter_ios_android_platforms/data/models/auth/registration_user_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/login_entity.dart';
import 'package:flutter_ios_android_platforms/services/firebase_auth_service.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';

class AuthRemoteDataSource {
  final ApiClient client;
  final FirebaseAuthService firebaseAuthService;

  AuthRemoteDataSource(this.client, this.firebaseAuthService);

  /// Đăng ký user
  Future<void> register(RegisterUserModel user) async {
    final res = await client.post(Endpoints.register, data: user.toJson());

    if (res.success != true) {
      throw Exception(res.message ?? 'Đăng ký thất bại');
    }
  }

  /// Đăng nhập user → trả về Model
  Future<AuthUserModel> login(LoginEntity payload) async {
    // 1. Lấy idToken từ Firebase
    final idToken = await firebaseAuthService.signInAndGetToken(
      payload.email,
      payload.password,
    );

    // 2. Gọi API backend
    final raw = await client.get(
      Endpoints.login,
      headers: {"Authorization": "Bearer $idToken"},
    );

    logger.i("raw: ${raw.data}");

    if (raw.success == false) {
      throw Failure(raw.message ?? "Đăng nhập thất bại");
    }

    final userJson = raw.data["data"]["user"];
    if (userJson == null) throw Failure("Người dùng ko tồn tại");

    return AuthUserModel.fromJson(userJson);
  }

  Future<void> logout() async {
    try {
      await firebaseAuthService.signOut();
    } catch (e) {
      throw new Exception(e);
    }
  }

  Future<AuthUserModel?> getCurrentUserFromBackend({
    required String idToken,
  }) async {
    try {
      final raw = await client.get(
        Endpoints.login, // hoặc endpoint riêng "me"
        headers: {"Authorization": "Bearer $idToken"},
      );

      logger.i("raw: ${raw.data}");

      if (raw.success == false) {
        throw Failure(raw.message ?? "Lấy thông tin user thất bại");
      }

      final userJson = raw.data["data"]["user"];
      if (userJson == null) return null;

      return AuthUserModel.fromJson(userJson);
    } catch (e) {
      logger.e("getCurrentUserFromBackend error: $e");
      return null;
    }
  }
}
