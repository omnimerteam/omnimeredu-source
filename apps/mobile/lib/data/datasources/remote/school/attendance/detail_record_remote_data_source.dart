import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/data/models/detail_record/detail_record_model.dart';
import 'package:flutter_ios_android_platforms/data/models/detail_record/detail_record_student_model.dart';

class DetailRecordRemoteDataSource {
  final ApiClient client;

  DetailRecordRemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  /// Cập nhật trạng thái điểm danh cho học sinh
  Future<ApiResponse<DetailRecordModel?>> updateStatusDetailRecord(
    DetailRecordModel data,
  ) async {
    if (data.id == null) {
      throw Exception("Hãy chọn bảng điểm danh để cập nhật");
    }

    final token = await _getIdToken();

    final res = await client.patch<DetailRecordModel?>(
      Endpoints.updateStatusDetailRecord(data.id!),
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: data.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return DetailRecordModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    return res;
  }

  // Lấy danh sach các record của bảng điểm danh
  Future<ApiResponse<List<DetailRecordStudentModel>?>> getAttendanceRecordsById(
    String attendanceId,
  ) async {
    final token = await _getIdToken();

    final res = await client.get<List<DetailRecordStudentModel>?>(
      Endpoints.getAttendanceRecordsById(attendanceId),
      headers: {if (token != null) "Authorization": "Bearer $token"},
      parser: (data) {
        if (data is List) {
          return data
              .map(
                (e) => DetailRecordStudentModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    return res;
  }
}
