import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/data/models/teaching_assignment/teaching_assignment_model.dart';

class TeachingAssignmentRemoteDataSource {
  final ApiClient client;

  TeachingAssignmentRemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  /// 🔹 Lấy danh sách teaching assignment theo teacherId + schoolId
  Future<ApiResponse<TeachingAssignmentModel?>>
  getTeachingAssignmentByTeacherAndSchoolId(
    String teacherId,
    String schoolId,
  ) async {
    final token = await _getIdToken();

    final res = await client.get<TeachingAssignmentModel?>(
      Endpoints.teachingAssignmentByTeacherIdAndSchoolId(teacherId, schoolId),
      headers: {if (token != null) "Authorization": "Bearer $token"},
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return TeachingAssignmentModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu teaching assignment hợp lệ");
      },
    );

    return res; // 🔹 giữ nguyên ApiResponse
  }

  /// 🔹 Tạo teaching assignment
  Future<ApiResponse<TeachingAssignmentModel>> createTeachingAssignment(
    TeachingAssignmentModel assignment,
  ) async {
    final token = await _getIdToken();

    final res = await client.post<TeachingAssignmentModel>(
      Endpoints.teachingAssignment,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: assignment.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return TeachingAssignmentModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu teaching assignment hợp lệ");
      },
    );

    return res;
  }

  /// 🔹 Cập nhật teaching assignment
  Future<ApiResponse<TeachingAssignmentModel>> updateTeachingAssignment(
    TeachingAssignmentModel assignment,
  ) async {
    final token = await _getIdToken();

    final res = await client.put<TeachingAssignmentModel>(
      Endpoints.teachingAssignmentId(assignment.id!),
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: assignment.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return TeachingAssignmentModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu teaching assignment hợp lệ");
      },
    );

    return res;
  }

  /// 🔹 Xóa teaching assignment
  Future<ApiResponse<void>> delete(String id) async {
    final token = await _getIdToken();

    final res = await client.delete<void>(
      Endpoints.teachingAssignmentId(id),
      headers: {if (token != null) "Authorization": "Bearer $token"},
    );

    return res;
  }
}
