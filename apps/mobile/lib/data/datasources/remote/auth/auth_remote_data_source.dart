import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/core/error/failures.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/data/models/auth/auth_user_model.dart';
import 'package:flutter_ios_android_platforms/data/models/auth/registration_user_model.dart';
import 'package:flutter_ios_android_platforms/data/models/user/base_user_model.dart';
import 'package:flutter_ios_android_platforms/data/models/user/school_admin_model.dart';
import 'package:flutter_ios_android_platforms/data/models/user/staff_mode.dart';
import 'package:flutter_ios_android_platforms/data/models/user/student_model.dart';
import 'package:flutter_ios_android_platforms/data/models/user/teacher_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/login_entity.dart';
import 'package:flutter_ios_android_platforms/services/firebase_auth_service.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';

class AuthRemoteDataSource {
  final ApiClient client;
  final FirebaseAuthService firebaseAuthService;

  AuthRemoteDataSource(this.client, this.firebaseAuthService);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

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

    if (raw.success == false) {
      throw Exception(raw.message ?? "Đăng nhập thất bại");
    }

    final userJson = raw.data["user"];
    if (userJson == null) throw Exception("Người dùng ko tồn tại");

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

      if (raw.success == false) {
        throw Failure(raw.message ?? "Lấy thông tin user thất bại");
      }

      final userJson = raw.data["user"];
      if (userJson == null) return null;

      return AuthUserModel.fromJson(userJson);
    } catch (e) {
      logger.e("getCurrentUserFromBackend error: $e");
      return null;
    }
  }

  Future<ApiResponse<void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    final token = await _getIdToken();

    final res = await client.patch<void>(
      Endpoints.changePassword,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: {"oldPassword": oldPassword, "newPassword": newPassword},
    );

    return res;
  }

  Future<ApiResponse<BaseUserModel>> getUserById(String userId) async {
    final token = await _getIdToken();

    final res = await client.get<Map<String, dynamic>>(
      Endpoints.personnelId(userId),
      headers: {if (token != null) "Authorization": "Bearer $token"},
    );

    // Nếu lỗi server hoặc không có data
    if (res.data == null) {
      return ApiResponse.error("Không tìm thấy dữ liệu người dùng");
    }

    final json = res.data!;
    final roleKey = json['roleKey'] as String?;

    late BaseUserModel model;

    switch (roleKey) {
      case 'Student':
        model = StudentModel.fromJson(json);
        break;
      case 'Teacher':
        model = TeacherModel.fromJson(json);
        break;
      case 'SchoolAdmin':
        model = SchoolAdminModel.fromJson(json);
        break;
      case 'Staff':
        model = StaffModel.fromJson(json);
        break;
      default:
        // fallback: parse cơ bản
        BaseUserModel.fromJson(
          json,
          roleKey: roleKey!.isEmpty ? 'BaseUser' : roleKey,
        );
        break;
    }

    return ApiResponse.success(model, message: res.message ?? "Thành công");
  }
}
