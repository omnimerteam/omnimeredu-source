import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/data/models/user/staff_mode.dart';

class StaffRemoteDataSource {
  final ApiClient client;

  StaffRemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  Future<ApiResponse<StaffModel?>> updateStaff(StaffModel data) async {
    if (data.id == null) {
      throw Exception("Thiếu dữ liệu");
    }

    try {
      final token = await _getIdToken();

      final res = await client.put<StaffModel?>(
        Endpoints.teacherId(data.id!),
        headers: {if (token != null) "Authorization": "Bearer $token"},
        data: data.toJson(),
        parser: (data) {
          if (data is Map<String, dynamic>) {
            return StaffModel.fromJson(data);
          }
          throw Exception("API không trả về dữ liệu isVerified hợp lệ");
        },
      );

      return res;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
