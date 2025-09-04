import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';

class ClassRemoteDataSource {
  final ApiClient client;
  ClassRemoteDataSource(this.client);

  Future<List<ClassSearchEntity>> searchClassesInSchool(
    String schoolId,
    String? query,
  ) async {
    final res = await client.get(
      Endpoints.searchClassesInSchool,
      query: {"schoolId": schoolId, "query": query},
    );
    final List<dynamic> list = res.data["data"];
    if (list.isEmpty) {
      // Ném exception nếu không có lớp nào phù hợp
      throw Exception("Không có lớp phù hợp");
    }

    final List<ClassSearchEntity> classes = list
        .map(
          (e) => ClassSearchEntity(
            id: e["_id"].toString(),
            name: e["name"].toString(),
            code: e["code"].toString(),
            schoolId: e["schoolId"].toString(),
          ),
        )
        .toList();

    return classes;
  }
}
