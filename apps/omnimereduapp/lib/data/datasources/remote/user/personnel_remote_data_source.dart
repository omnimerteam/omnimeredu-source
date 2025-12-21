import '../../../../core/add_jwt.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints.dart';
import '../../../models/user/personnel_model.dart';
import '../../../../domain/entities/query/default_query_entity.dart';
import '../base_remote_data_source.dart';

class PersonnelRemoteDataSource extends BaseRemoteDataSource {
  PersonnelRemoteDataSource(ApiClient client, AppAuthProvider authProvider)
    : super(client, authProvider);

  /// Lấy danh sách nhân sự (có thể kèm query filter)
  Future<ApiResponse<List<PersonnelModel>>> getAllPersonnelFromSchool(
    DefaultQueryEntity query,
  ) async {
    final headers = await authHeaders;
    final queryParams = query.toQueryBuilder().build();

    final res = await client.get<List<PersonnelModel>>(
      Endpoints.personnel,
      headers: headers,
      query: queryParams,
      parser: (data) {
        if (data is List) {
          return data
              .map((e) => PersonnelModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        throw Exception("API không trả về danh sách nhân sự hợp lệ");
      },
    );

    return res;
  }

  Future<ApiResponse<bool>> updateVerified(
    String personnelId,
    bool isVerified,
  ) async {
    final headers = await authHeaders;

    final res = await client.patch<bool>(
      Endpoints.updateVerified(personnelId),
      headers: headers,
      data: {"isVerified": isVerified},
      parser: (data) {
        if (data is Map<String, dynamic> && data["isVerified"] != null) {
          return data["isVerified"] as bool;
        }
        throw Exception("API không trả về dữ liệu isVerified hợp lệ");
      },
    );

    return res;
  }

  Future<ApiResponse<void>> dismissPersonnel(String personnelId) async {
    final headers = await authHeaders;

    final res = await client.patch<bool>(
      Endpoints.dismissPersonnel(personnelId),
      headers: headers,
    );

    return res;
  }

  Future<ApiResponse<void>> updateAvatar(
    String avatarPath,
    String avatarUrl,
  ) async {
    try {
      final headers = await authHeaders;

      final res = await client.patch<void>(
        Endpoints.updateAvatar,
        headers: headers,
        data: {"avatarPath": avatarPath, "avatarUrl": avatarUrl},
      );

      return res;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
