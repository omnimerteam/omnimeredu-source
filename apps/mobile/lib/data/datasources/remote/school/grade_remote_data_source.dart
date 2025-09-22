import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/data/models/grade/grade_model.dart';
import 'package:flutter_ios_android_platforms/data/models/grade/grade_select_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';

class GradeRemoteDataSource {
  final ApiClient client;

  GradeRemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  /// 🔹 Lấy tất cả grade
  Future<List<GradeModel>> getAllGrades(DefaultQueryEntity query) async {
    final token = await _getIdToken();
    final queryParams = query.toQueryBuilder().build();

    final res = await client.get<List<GradeModel>>(
      Endpoints.grades,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      query: queryParams,
      parser: (data) {
        if (data is List) {
          return data
              .map((e) => GradeModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        throw Exception("API không trả về danh sách grade hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể lấy danh sách grade");
    }
  }

  /// 🔹 Lấy grade theo id
  Future<GradeModel> getGradeById(String id) async {
    final token = await _getIdToken();

    final res = await client.get<GradeModel>(
      Endpoints.gradeId(id),
      headers: {if (token != null) "Authorization": "Bearer $token"},
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return GradeModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu grade hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể lấy thông tin grade");
    }
  }

  /// 🔹 Tạo grade mới
  Future<GradeModel> createGrade(GradeModel grade) async {
    final token = await _getIdToken();

    final res = await client.post<GradeModel>(
      Endpoints.grades,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: grade.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return GradeModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu grade hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể tạo grade mới");
    }
  }

  /// 🔹 Cập nhật grade
  Future<GradeModel> updateGrade(GradeModel grade) async {
    final id = grade.id;

    final token = await _getIdToken();

    final res = await client.put<GradeModel>(
      Endpoints.gradeId(id!),
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: grade.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return GradeModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu grade hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể cập nhật grade");
    }
  }

  /// 🔹 Xóa grade
  Future<void> deleteGrade(String id) async {
    final token = await _getIdToken();

    final res = await client.delete<void>(
      Endpoints.gradeId(id),
      headers: {if (token != null) "Authorization": "Bearer $token"},
    );

    if (res.success) {
      return;
    } else {
      throw Exception(res.message ?? "Không thể xóa grade");
    }
  }

  /// 🔹 Lấy grade cho selectbox
  Future<List<GradeSelectModel>> getGradesForSelect() async {
    final token = await _getIdToken();

    final res = await client.get<List<GradeSelectModel>>(
      Endpoints.gradeSelect,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      parser: (data) {
        if (data is List) {
          return data
              .map((e) => GradeSelectModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        throw Exception("API không trả về danh sách grade select hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể lấy danh sách grade select");
    }
  }
}
