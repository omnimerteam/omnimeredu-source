import '../../../../core/add_jwt.dart';
import '../../../../core/constants/enum_constant.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints.dart';
import '../../../models/user/school_admin_model.dart';
import '../base_remote_data_source.dart';

class SchoolAdminRemoteDataSource extends BaseRemoteDataSource {
  SchoolAdminRemoteDataSource(ApiClient client, AppAuthProvider authProvider)
    : super(client, authProvider);

  /// Lấy danh sách nhân sự (có thể kèm query filter)
  Future<ApiResponse<SchoolAdminPositionEnum>> updatePositionSchoolAdmin(
    String schoolAdminId,
    SchoolAdminPositionEnum position,
  ) async {
    final headers = await authHeaders;

    final res = await client.patch<SchoolAdminPositionEnum>(
      Endpoints.updatePositionSchoolAdmin(schoolAdminId),
      headers: headers,
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
      final headers = await authHeaders;

      final res = await client.patch<SchoolAdminModel?>(
        Endpoints.schoolAdminId(data.id!),
        headers: headers,
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
