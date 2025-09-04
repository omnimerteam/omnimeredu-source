import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/domain/entities/school/school_search_entity.dart';

class SchoolRemoteDataSource {
  final ApiClient client;
  SchoolRemoteDataSource(this.client);

  Future<List<SchoolSearchEntity>> searchSchoolsByLevel(
    String educationLevel,
    String? query,
  ) async {
    final res = await client.get(
      Endpoints.searchSchoolByEducationLevel,
      query: {
        "educationLevel": educationLevel,
        if (query != null && query.isNotEmpty) "query": query,
      },
    );

    final List<dynamic> list = res.data["data"];

    if (list.isEmpty) {
      // Ném exception nếu không có trường nào phù hợp
      throw Exception("Không có trường phù hợp");
    }

    // Chuyển sang List<SchoolSearchEntity>
    final List<SchoolSearchEntity> schools = list
        .map(
          (e) => SchoolSearchEntity(
            id: e["_id"] as String,
            name: e["name"] as String,
            code: e["code"] as String,
          ),
        )
        .toList();

    return schools;
  }
}
