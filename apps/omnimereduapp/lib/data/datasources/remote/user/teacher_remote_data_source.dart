import '../../../../core/add_jwt.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints.dart';
import '../../../models/user/teacher_model.dart';
import '../base_remote_data_source.dart';

class TeacherRemoteDataSource extends BaseRemoteDataSource {
  TeacherRemoteDataSource(ApiClient client, AppAuthProvider authProvider)
    : super(client, authProvider);

  Future<ApiResponse<TeacherModel?>> updateTeacher(TeacherModel data) async {
    if (data.id == null) {
      throw Exception("Thiếu dữ liệu");
    }

    try {
      final headers = await authHeaders;

      final res = await client.put<TeacherModel?>(
        Endpoints.teacherId(data.id!),
        headers: headers,
        data: data.toJson(),
        parser: (data) {
          if (data is Map<String, dynamic>) {
            return TeacherModel.fromJson(data);
          }
          throw Exception("API không trả về dữ liệu isVerified hợp lệ");
        },
      );

      return res;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
