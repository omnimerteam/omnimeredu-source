import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
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
  Future<List<PersonnelModel>> getAllPersonnel(DefaultQueryEntity query) async {
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

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể lấy danh sách nhân sự");
    }
  }
}
