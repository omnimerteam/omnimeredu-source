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
    final res = await client.get<List<ClassSearchEntity>>(
      Endpoints.searchClassesInSchool,
      query: {"schoolId": schoolId, "query": query},
      parser: (data) {
        if (data is List) {
          return data
              .map(
                (e) => ClassSearchEntity(
                  id: e["_id"].toString(),
                  name: e["name"].toString(),
                  code: e["code"].toString(),
                  schoolId: e["schoolId"].toString(),
                ),
              )
              .toList();
        }
        throw Exception("API không trả về danh sách lớp học hợp lệ");
      },
    );

    if (res.success) {
      final list = res.data ?? [];
      if (list.isEmpty) {
        throw Exception("Không có lớp phù hợp");
      }
      return list;
    } else {
      throw Exception(res.message ?? "Không thể tìm lớp trong trường");
    }
  }
}
