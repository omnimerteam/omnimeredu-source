import '../../../../../core/add_jwt.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_response.dart';
import '../../../../../core/network/endpoints.dart';
import '../../../../models/class/class_search_model.dart';
import '../../../../models/class/class_teacher_assign_model.dart';
import '../../../../models/teaching_assignment/teaching_assignment_model.dart';
import '../../base_remote_data_source.dart';

class TeachingAssignmentRemoteDataSource extends BaseRemoteDataSource {
  TeachingAssignmentRemoteDataSource(
    ApiClient client,
    AppAuthProvider authProvider,
  ) : super(client, authProvider);

  /// 🔹 Lấy danh sách teaching assignment theo teacherId + schoolId
  Future<ApiResponse<TeachingAssignmentModel?>>
  getTeachingAssignmentByTeacherClassAndSchool(
    String teacherId,
    String schoolId,
    String classId,
  ) async {
    final headers = await authHeaders;

    final res = await client.get<TeachingAssignmentModel?>(
      Endpoints.getTeachingAssignmentByTeacherClassAndSchool(
        teacherId,
        schoolId,
        classId,
      ),
      headers: headers,
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return TeachingAssignmentModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    return res; // 🔹 giữ nguyên ApiResponse
  }

  /// 🔹 Tạo teaching assignment
  Future<ApiResponse<TeachingAssignmentModel>> createTeachingAssignment(
    TeachingAssignmentModel assignment,
  ) async {
    final headers = await authHeaders;

    final res = await client.post<TeachingAssignmentModel>(
      Endpoints.teachingAssignment,
      headers: headers,
      data: assignment.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return TeachingAssignmentModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    return res;
  }

  /// 🔹 Cập nhật teaching assignment
  Future<ApiResponse<TeachingAssignmentModel>> updateTeachingAssignment(
    TeachingAssignmentModel assignment,
  ) async {
    final headers = await authHeaders;

    final res = await client.put<TeachingAssignmentModel>(
      Endpoints.teachingAssignmentId(assignment.id!),
      headers: headers,
      data: assignment.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return TeachingAssignmentModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    return res;
  }

  /// 🔹 Xóa teaching assignment
  Future<ApiResponse<void>> delete(String id) async {
    final headers = await authHeaders;

    final res = await client.delete<void>(
      Endpoints.teachingAssignmentId(id),
      headers: headers,
    );

    return res;
  }

  // Lấy danh sách lớp học của giáo viên quản lý
  Future<ApiResponse<List<ClassTeacherAssignModel>?>>
  getClassTeacherAssignments(String teacherId, String schoolId) async {
    final headers = await authHeaders;

    final res = await client.get<List<ClassTeacherAssignModel>?>(
      Endpoints.getAllAssignmentForTeacherInSchool(teacherId, schoolId),
      headers: headers,
      parser: (data) {
        if (data is List) {
          return data
              .map(
                (e) =>
                    ClassTeacherAssignModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    return res;
  }

  // Lấy danh sách lớp cô giáo quản lý cho selectors
  Future<ApiResponse<List<ClassSearchModel>?>>
  getClassesTeacherAssignByTeacherId(String teacherId) async {
    final headers = await authHeaders;

    final res = await client.get<List<ClassSearchModel>?>(
      Endpoints.getClassesTeacherAssignByTeacherId(teacherId),
      headers: headers,
      parser: (data) {
        if (data is List) {
          return data
              .map((e) => ClassSearchModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    return res;
  }
}
