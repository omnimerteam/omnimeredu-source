import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/core/app_constants.dart';
import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/data/models/class/class_detail_view_model.dart';
import 'package:flutter_ios_android_platforms/data/models/class/class_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';

class ClassRemoteDataSource {
  final ApiClient client;

  ClassRemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  // Tìm kiếm lớp học trong trường
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

  /// Danh sác lớp học bằng ClassDetail View Model
  Future<List<ClassDetailViewModel>> getAllClassDetailView(
    String sort, {
    int page = AppConstants.defaultPage,
    int limit = AppConstants.defaultLimit,
  }) async {
    final token = await _getIdToken();

    final res = await client.get<List<ClassDetailViewModel>>(
      Endpoints.classes,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      query: {
        "page": page.toString(),
        "limit": limit.toString(),
        "sort": sort.isNotEmpty ? sort : AppConstants.nameSort,
      },
      parser: (data) {
        if (data is List) {
          return data
              .map(
                (e) => ClassDetailViewModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
        throw Exception("API không trả về danh sách lớp hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể lấy danh sách lớp");
    }
  }

  /// Danh sác lớp học bằng ClassDetail View Model
  Future<ClassModel> getClassById(String id) async {
    final token = await _getIdToken();

    final res = await client.get<ClassModel>(
      Endpoints.classId(id),
      headers: {if (token != null) "Authorization": "Bearer $token"},
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return ClassModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu lớp hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể lấy danh sách lớp");
    }
  }

  /// Tạo lớp học mới
  Future<ClassModel> createClass(ClassModel createClassData) async {
    final token = await _getIdToken();

    final res = await client.post<ClassModel>(
      Endpoints.classes,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: createClassData.toJson(), // gửi data mới
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return ClassModel.fromJson(data); // nhận lại bản đã cập nhật
        }
        throw Exception("API không trả về dữ liệu lớp hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể tạo mới lớp");
    }
  }

  /// Cập nhật thông tin lớp học
  Future<ClassModel> updateClass(ClassModel updateClassData) async {
    final id = updateClassData.id;
    if (id == null) {
      throw Exception("Lớp chưa được chọn");
    }

    final token = await _getIdToken();

    final res = await client.put<ClassModel>(
      Endpoints.classId(id),
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: updateClassData.toJson(), // gửi data mới
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return ClassModel.fromJson(data); // nhận lại bản đã cập nhật
        }
        throw Exception("API không trả về dữ liệu lớp hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!; // bản school đã cập nhật
    } else {
      throw Exception(res.message ?? "Không thể cập nhật thông tin lớp");
    }
  }

  // Xóa lớp của schoolAdmin
  Future<void> deleteClass(String id) async {
    final token = await _getIdToken();

    final res = await client.delete<void>(
      Endpoints.classId(id),
      headers: {if (token != null) "Authorization": "Bearer $token"},
    );

    if (res.success) {
      // Xóa thành công, không cần trả về gì
      return;
    } else {
      // Nếu có message từ server thì throw, nếu không thì throw message mặc định
      throw Exception(res.message ?? "Không thể xóa lớp");
    }
  }
}
