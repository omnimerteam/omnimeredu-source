import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/data/models/user/student_model.dart';
import 'package:flutter_ios_android_platforms/data/models/user/student_selector_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';

class StudentRemoteDataSource {
  final ApiClient client;

  StudentRemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  /// Lấy danh sách học sinh (có thể kèm query filter)
  Future<List<StudentModel>> getAllStudents(DefaultQueryEntity query) async {
    final token = await _getIdToken();
    final queryParams = query.toQueryBuilder().build();

    final res = await client.get<List<StudentModel>>(
      Endpoints.students,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      query: queryParams,
      parser: (data) {
        if (data is List) {
          return data
              .map((e) => StudentModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        throw Exception("API không trả về danh sách học sinh hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể lấy danh sách học sinh");
    }
  }

  /// Lấy thông tin học sinh theo ID
  Future<StudentModel> getStudentById(String id) async {
    final token = await _getIdToken();

    final res = await client.get<StudentModel>(
      Endpoints.studentId(id),
      headers: {if (token != null) "Authorization": "Bearer $token"},
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return StudentModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu học sinh hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể lấy thông tin học sinh");
    }
  }

  /// Tạo học sinh mới
  Future<StudentModel> createStudent(StudentModel studentData) async {
    final token = await _getIdToken();

    final res = await client.post<StudentModel>(
      Endpoints.students,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: studentData.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return StudentModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu học sinh hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể tạo mới học sinh");
    }
  }

  /// Cập nhật học sinh
  Future<StudentModel> updateStudent(StudentModel studentData) async {
    final id = studentData.id;
    if (id == null) {
      throw Exception("Học sinh chưa được chọn");
    }

    final token = await _getIdToken();

    final res = await client.put<StudentModel>(
      Endpoints.studentId(id),
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: studentData.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return StudentModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu học sinh hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể cập nhật học sinh");
    }
  }

  /// Xóa học sinh
  Future<void> deleteStudent(String id) async {
    final token = await _getIdToken();

    final res = await client.delete<void>(
      Endpoints.studentId(id),
      headers: {if (token != null) "Authorization": "Bearer $token"},
    );

    if (!res.success) {
      throw Exception(res.message ?? "Không thể xóa học sinh");
    }
  }

  Future<ApiResponse<List<StudentSelectorModel>?>> getStudentSelector(
    String? gradeId,
  ) async {
    final token = await _getIdToken();

    final res = await client.get<List<StudentSelectorModel>?>(
      Endpoints.getStudentSelector,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      query: {"gradeId": gradeId},
      parser: (data) {
        if (data is List) {
          return data
              .map(
                (e) => StudentSelectorModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
        throw Exception("API không trả về danh sách hợp lệ");
      },
    );

    return res;
  }
}
