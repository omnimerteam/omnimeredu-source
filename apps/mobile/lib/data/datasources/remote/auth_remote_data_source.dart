import 'package:dio/dio.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/data/models/user_model.dart';
import 'package:flutter_ios_android_platforms/services/firebase_auth_service.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/endpoints.dart';
import '../../models/base_user_model.dart';
import '../../models/role_specific_model.dart';
import '../../models/school_data_model.dart';

class AuthRemoteDataSource {
  final ApiClient client;
  final FirebaseAuthService firebaseAuthService;
  AuthRemoteDataSource(this.client, this.firebaseAuthService);

  Future<void> register({
    required String email,
    required String password,
    String? schoolId,
    String? classId,
    required BaseUserModel baseUserInfo,
    required RoleSpecificModel specificInfo,
    SchoolDataModel? schoolData,
  }) async {
    final payload = {
      'email': email,
      'password': password,
      if (schoolId != null) 'schoolId': schoolId,
      if (classId != null) 'classId': classId,
      'baseUserInfo': baseUserInfo.toJson(),
      'specificInfo': specificInfo.toJson(),
      if (schoolData != null) 'schoolData': schoolData.toJson(),
    };

    final Response res = await client.post(Endpoints.register, data: payload);
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Register failed: ${res.statusCode}');
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    // 1. Lấy idToken từ FirebaseAuthService
    final idToken = await firebaseAuthService.signInAndGetToken(
      email,
      password,
    );

    // 2. Gọi API backend
    final raw = await client.get(
      Endpoints.login,
      headers: {"Authorization": "Bearer $idToken"},
    );

    logger.i("Login raw response: ${raw}");

    if (raw["success"] != true) {
      throw Exception(raw["message"] ?? "Đăng nhập thất bại");
    }

    return UserModel.fromJson(raw["data"]);
  }
}
