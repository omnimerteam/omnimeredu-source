import '../../../../core/add_jwt.dart';
import '../../../../core/constants/enum_constant.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/utils/logger.dart';
import '../../../models/school/school_model.dart';
import '../../../../domain/entities/school/school_search_entity.dart';
import '../base_remote_data_source.dart';

class SchoolRemoteDataSource extends BaseRemoteDataSource {
  SchoolRemoteDataSource(ApiClient client, AppAuthProvider authProvider)
    : super(client, authProvider);

  /// Lấy chi tiết trường cho SchoolAdmin
  Future<SchoolModel?> getSchoolDetailForSchoolAdmin() async {
    final headers = await authHeaders;

    try {
      final res = await client.get<SchoolModel>(
        Endpoints.getSchoolDetailForSchoolAdmin,
        headers: headers,
        parser: (data) {
          if (data is Map<String, dynamic>) {
            return SchoolModel.fromJson(data);
          }
          throw Exception("API không trả về dữ liệu trường hợp lệ");
        },
      );

      if (res.success && res.data != null) {
        return res.data!;
      }

      return null;
    } catch (e) {
      logger.e("Lỗi khi lấy thông tin trường: $e");
      return null;
    }
  }

  /// Tạo trường học mới
  Future<SchoolModel> createSchool(SchoolModel createSchoolData) async {
    final headers = await authHeaders;

    final res = await client.post<SchoolModel>(
      Endpoints.schools,
      headers: headers,
      data: createSchoolData.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return SchoolModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu trường hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể tạo mới trường");
    }
  }

  /// Cập nhật thông tin trường học
  Future<SchoolModel> updateSchool(SchoolModel updateSchoolData) async {
    final headers = await authHeaders;

    final res = await client.put<SchoolModel>(
      Endpoints.schools,
      headers: headers,
      data: updateSchoolData.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return SchoolModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu trường hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể cập nhật thông tin trường");
    }
  }

  // Xóa trường của schoolAdmin
  Future<void> deleteSchool() async {
    final headers = await authHeaders;

    final res = await client.delete<void>(Endpoints.schools, headers: headers);

    if (res.success) {
      return;
    } else {
      throw Exception(res.message ?? "Không thể xóa trường");
    }
  }

  Future<List<SchoolSearchEntity>> searchSchoolsByLevel(
    EducationSystemLevelsEnum educationLevel,
    String? query,
  ) async {
    final res = await client.get<List<SchoolSearchEntity>>(
      Endpoints.searchSchoolByEducationLevel,
      query: {
        "educationLevel": educationLevel.name,
        if (query != null && query.isNotEmpty) "query": query,
      },
      parser: (data) {
        if (data is List) {
          return data
              .map(
                (e) => SchoolSearchEntity(
                  id: e["_id"].toString(),
                  name: e["name"].toString(),
                  code: e["code"].toString(),
                ),
              )
              .toList();
        }
        throw Exception("API không trả về danh sách trường hợp lệ");
      },
    );

    if (res.success) {
      final schools = res.data ?? [];
      if (schools.isEmpty) {
        throw Exception("Không có trường phù hợp");
      }
      return schools;
    } else {
      throw Exception(res.message ?? "Không thể tìm trường");
    }
  }
}
