import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/data/models/user/school_admin_model.dart';

class SchoolAdminRemoteDataSource {
  final ApiClient client;

  SchoolAdminRemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  /// Lấy danh sách nhân sự (có thể kèm query filter)
  Future<ApiResponse<SchoolAdminPositionEnum>> updatePositionSchoolAdmin(
    String schoolAdminId,
    SchoolAdminPositionEnum position,
  ) async {
    final token = await _getIdToken();

    final res = await client.patch<SchoolAdminPositionEnum>(
      Endpoints.updatePositionSchoolAdmin(schoolAdminId),
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: {"position": position.name},
      parser: (data) {
        if (data is Map<String, dynamic> && data["position"] != null) {
          return SchoolAdminPositionEnum.fromString(
            data["position"] as String?,
          );
        }
        throw Exception("API không trả về dữ liệu position hợp lệ");
      },
    );

    return res;
  }

  Future<ApiResponse<SchoolAdminModel?>> updateSchoolAdmin(
    SchoolAdminModel data,
  ) async {
    if (data.id == null) throw Exception("Thiếu dữ liệu để cập nhật");

    try {
      final token = await _getIdToken();

      final res = await client.patch<SchoolAdminModel?>(
        Endpoints.schoolAdminId(data.id!),
        headers: {if (token != null) "Authorization": "Bearer $token"},
        data: data.toJson(),
        parser: (data) {
          if (data is Map<String, dynamic>) {
            return SchoolAdminModel.fromJson(data);
          }
          throw Exception("API không trả về dữ liệu position hợp lệ");
        },
      );

      return res;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
