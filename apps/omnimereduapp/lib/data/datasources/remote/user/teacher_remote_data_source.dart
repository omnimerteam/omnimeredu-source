import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints.dart';
import '../../../models/user/teacher_model.dart';

class TeacherRemoteDataSource {
  final ApiClient client;

  TeacherRemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  Future<ApiResponse<TeacherModel?>> updateTeacher(TeacherModel data) async {
    if (data.id == null) {
      throw Exception("Thiếu dữ liệu");
    }

    try {
      final token = await _getIdToken();

      final res = await client.put<TeacherModel?>(
        Endpoints.teacherId(data.id!),
        headers: {if (token != null) "Authorization": "Bearer $token"},
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
