import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/data/models/user/personnel_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';

class PersonnelRemoteDataSource {
  final ApiClient client;

  PersonnelRemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  /// Lấy danh sách nhân sự (có thể kèm query filter)
  Future<ApiResponse<List<PersonnelModel>>> getAllPersonnelFromSchool(
    DefaultQueryEntity query,
  ) async {
    final token = await _getIdToken();
    final queryParams = query.toQueryBuilder().build();

    final res = await client.get<List<PersonnelModel>>(
      Endpoints.personnel,
      headers: {if (token != null) "Authorization": "Bearer $token"},
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
    final token = await _getIdToken();

    final res = await client.patch<bool>(
      Endpoints.updateVerified(personnelId),
      headers: {if (token != null) "Authorization": "Bearer $token"},
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
    final token = await _getIdToken();

    final res = await client.patch<bool>(
      Endpoints.dismissPersonnel(personnelId),
      headers: {if (token != null) "Authorization": "Bearer $token"},
    );

    return res;
  }
}
