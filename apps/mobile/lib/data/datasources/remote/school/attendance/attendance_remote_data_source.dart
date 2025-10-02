import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/data/models/attendance/attendance_model.dart';
import 'package:flutter_ios_android_platforms/data/models/view_model/attendance_record_model.dart';

class AttendanceRemoteDataSource {
  final ApiClient client;

  AttendanceRemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  /// 🔹 Tạo teaching assignment
  Future<ApiResponse<AttendanceModel?>> initializeClassAttendance(
    AttendanceModel assignment,
  ) async {
    final token = await _getIdToken();

    final res = await client.post<AttendanceModel?>(
      Endpoints.initializeClassAttendance,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: assignment.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return AttendanceModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    return res;
  }

  Future<ApiResponse<AttendanceRecordViewModel?>> getClassAttendanceRecordView(
    DateTime date,
    String classId,
  ) async {
    final token = await _getIdToken();

    final res = await client.get<AttendanceRecordViewModel?>(
      Endpoints.getClassAttendanceRecordView,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      query: {"date": date.toUtc().toIso8601String(), "classId": classId},
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return AttendanceRecordViewModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    return res;
  }
}
