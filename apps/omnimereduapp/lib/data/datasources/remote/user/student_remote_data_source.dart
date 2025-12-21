import '../../../../core/add_jwt.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints.dart';
import '../../../models/user/student_model.dart';
import '../../../models/user/student_selector_model.dart';
import '../../../../domain/entities/query/default_query_entity.dart';
import '../base_remote_data_source.dart';

class StudentRemoteDataSource extends BaseRemoteDataSource {
  StudentRemoteDataSource(ApiClient client, AppAuthProvider authProvider)
    : super(client, authProvider);

  /// Lấy danh sách học sinh (có thể kèm query filter)
  Future<List<StudentModel>> getAllStudents(DefaultQueryEntity query) async {
    final headers = await authHeaders;
    final queryParams = query.toQueryBuilder().build();

    final res = await client.get<List<StudentModel>>(
      Endpoints.students,
      headers: headers,
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

    if (res.success) {
      return res.data ?? [];
    } else {
      throw Exception(res.message ?? "Không thể lấy danh sách học sinh");
    }
  }

  /// Lấy thông tin học sinh theo ID
  Future<StudentModel> getStudentById(String id) async {
    final headers = await authHeaders;

    final res = await client.get<StudentModel>(
      Endpoints.studentId(id),
      headers: headers,
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
    final headers = await authHeaders;

    final res = await client.post<StudentModel>(
      Endpoints.students,
      headers: headers,
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
  Future<ApiResponse<StudentModel?>> updateStudent(
    StudentModel studentData,
  ) async {
    if (studentData.id == null) {
      throw Exception("Thiếu dữ liệu");
    }

    try {
      final headers = await authHeaders;

      final res = await client.put<StudentModel?>(
        Endpoints.studentId(studentData.id!),
        headers: headers,
        data: studentData.toJson(),
        parser: (data) {
          if (data is Map<String, dynamic>) {
            return StudentModel.fromJson(data);
          }
          throw Exception("API không trả về dữ liệu isVerified hợp lệ");
        },
      );

      return res;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Xóa học sinh
  Future<void> deleteStudent(String id) async {
    final headers = await authHeaders;

    final res = await client.delete<void>(
      Endpoints.studentId(id),
      headers: headers,
    );

    if (!res.success) {
      throw Exception(res.message ?? "Không thể xóa học sinh");
    }
  }

  Future<ApiResponse<List<StudentSelectorModel>?>> getStudentSelector(
    String? gradeId,
  ) async {
    final headers = await authHeaders;

    final res = await client.get<List<StudentSelectorModel>?>(
      Endpoints.getStudentSelector,
      headers: headers,
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
