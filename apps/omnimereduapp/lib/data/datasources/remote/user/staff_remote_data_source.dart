import '../../../../core/add_jwt.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints.dart';
import '../../../models/user/staff_mode.dart';
import '../base_remote_data_source.dart';

class StaffRemoteDataSource extends BaseRemoteDataSource {
  StaffRemoteDataSource(ApiClient client, AppAuthProvider authProvider)
    : super(client, authProvider);

  Future<ApiResponse<StaffModel?>> updateStaff(StaffModel data) async {
    if (data.id == null) {
      throw Exception("Thiếu dữ liệu");
    }

    try {
      final headers = await authHeaders;

      final res = await client.put<StaffModel?>(
        Endpoints.personnelId(data.id!),
        headers: headers,
        data: data.toJson(),
        parser: (data) {
          if (data is Map<String, dynamic>) {
            return StaffModel.fromJson(data);
          }
          throw Exception("API không trả về dữ liệu hợp lệ");
        },
      );

      return res;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
