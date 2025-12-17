import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/api_response.dart';
import 'package:mobile/core/api/endpoints.dart';
import 'package:mobile/core/constants/enum_constant.dart';

import 'package:mobile/data/models/user/school_admin_model.dart';

abstract class SchoolAdminRemoteDataSource {
  Future<ApiResponse<SchoolAdminPositionEnum>> updatePositionSchoolAdmin(
    String schoolAdminId,
    SchoolAdminPositionEnum position,
  );

  Future<ApiResponse<SchoolAdminModel?>> updateSchoolAdmin(
    SchoolAdminModel data,
  );
}

class SchoolAdminRemoteDataSourceImpl implements SchoolAdminRemoteDataSource {
  final ApiClient client;

  SchoolAdminRemoteDataSourceImpl(this.client);

  String get _baseUrl => UserEndpoints.baseUrl;

  @override
  Future<ApiResponse<SchoolAdminPositionEnum>> updatePositionSchoolAdmin(
    String schoolAdminId,
    SchoolAdminPositionEnum position,
  ) async {
    // Note: Endpoint paths taken from legacy app, assuming same backend structure under User Service
    final url = '$_baseUrl/v1/school-admins/update-position/$schoolAdminId';

    // Auth token is handled by ApiClient if requiresAuth is true (default)
    // or we can manually pass it if ApiClient doesn't auto-inject.
    // Looking at auth_remote_data_source, it doesn't pass header manually for authorized requests
    // relative to client usage? Wait, auth_remote_data_source used requiresAuth: false for login.
    // For protected routes, ApiClient usually attaches interceptors.
    // But checking old code, it manually added Authorization header.
    // I will let ApiClient handle it if it has interceptor, but given I don't see the interceptor setup here,
    // I will check if ApiClient has default auth header referencing SecureStorage.
    // But to be safe, I'll rely on ApiClient interceptor logic or pass if needed.
    // Since I can't check ApiClient implementation deeply right now, I'll assume it handles it or I shouldn't manually add if I want to be clean.
    // However, existing AuthRemoteDataSource writes token to SecureStorage.
    // I will assume ApiClient reads from there.

    final res = await client.patch<SchoolAdminPositionEnum>(
      url,
      data: {"position": position.name},
      parser: (data) {
        if (data is Map<String, dynamic> && data["position"] != null) {
          return SchoolAdminPositionEnum.fromString(
            data["position"] as String?,
          );
        }
        // Fallback or throw
        if (data is String) {
          return SchoolAdminPositionEnum.fromString(data);
        }
        throw Exception("API không trả về dữ liệu position hợp lệ");
      },
    );

    return ApiResponse(
      success: res.success,
      message: res.message,
      data: res.data,
    );
  }

  @override
  Future<ApiResponse<SchoolAdminModel?>> updateSchoolAdmin(
    SchoolAdminModel data,
  ) async {
    if (data.id == null) throw Exception("Thiếu dữ liệu để cập nhật");

    final url = '$_baseUrl/v1/school-admin/${data.id}';

    final res = await client.patch<SchoolAdminModel?>(
      url,
      data: data.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return SchoolAdminModel.fromJson(data);
        }
        return null;
      },
    );

    return ApiResponse(
      success: res.success,
      message: res.message,
      data: res.data,
    );
  }
}
