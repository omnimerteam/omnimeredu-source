import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/enum_constant.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/utils/logger.dart';
import '../../../models/school/school_model.dart';
import '../../../../domain/entities/school/school_search_entity.dart';

class SchoolRemoteDataSource {
  final ApiClient client;
  SchoolRemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  /// Lấy chi tiết trường cho SchoolAdmin
  Future<SchoolModel?> getSchoolDetailForSchoolAdmin() async {
    final token = await _getIdToken();

    try {
      final res = await client.get<SchoolModel>(
        Endpoints.getSchoolDetailForSchoolAdmin,
        headers: {if (token != null) "Authorization": "Bearer $token"},
        parser: (data) {
          // Parser phải luôn trả SchoolModel, không trả null
          if (data is Map<String, dynamic>) {
            return SchoolModel.fromJson(data);
          }
          // Nếu data null hoặc kiểu khác → ném lỗi để bắt ngoài
          throw Exception("API không trả về dữ liệu trường hợp lệ");
        },
      );

      // Nếu thành công → trả model
      if (res.success && res.data != null) {
        return res.data!;
      }

      // Nếu API trả 404 hoặc không có dữ liệu → trả null
      return null;
    } catch (e) {
      // Bắt tất cả lỗi, log và trả null
      logger.e("Lỗi khi lấy thông tin trường: $e");
      return null;
    }
  }

  /// Tạo trường học mới
  Future<SchoolModel> createSchool(SchoolModel createSchoolData) async {
    final token = await _getIdToken();

    final res = await client.post<SchoolModel>(
      Endpoints.schools,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: createSchoolData.toJson(), // gửi data mới
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return SchoolModel.fromJson(data); // nhận lại bản đã cập nhật
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
    final token = await _getIdToken();

    final res = await client.put<SchoolModel>(
      Endpoints.schools,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: updateSchoolData.toJson(), // gửi data mới
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return SchoolModel.fromJson(data); // nhận lại bản đã cập nhật
        }
        throw Exception("API không trả về dữ liệu trường hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!; // bản school đã cập nhật
    } else {
      throw Exception(res.message ?? "Không thể cập nhật thông tin trường");
    }
  }

  // Xóa trường của schoolAdmin
  Future<void> deleteSchool() async {
    final token = await _getIdToken();

    final res = await client.delete<void>(
      Endpoints.schools,
      headers: {if (token != null) "Authorization": "Bearer $token"},
    );

    if (res.success) {
      // Xóa thành công, không cần trả về gì
      return;
    } else {
      // Nếu có message từ server thì throw, nếu không thì throw message mặc định
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
