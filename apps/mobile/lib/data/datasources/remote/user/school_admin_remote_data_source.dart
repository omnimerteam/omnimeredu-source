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
