import '../../../../../core/add_jwt.dart';
import 'package:omnimereduapp/data/models/attendance/export_file_model.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_response.dart';
import '../../../../../core/network/endpoints.dart';
import '../../../../models/attendance/attendance_class_model.dart';
import '../../../../models/attendance/attendance_model.dart';
import '../../../../models/view_model/attendance_record_model.dart';
import '../../../../../domain/entities/query/default_query_entity.dart';
import '../../base_remote_data_source.dart';

class AttendanceRemoteDataSource extends BaseRemoteDataSource {
  AttendanceRemoteDataSource(ApiClient client, AppAuthProvider authProvider)
    : super(client, authProvider);

  /// 🔹 Tạo teaching assignment
  Future<ApiResponse<AttendanceModel?>> initializeClassAttendance(
    AttendanceModel assignment,
  ) async {
    final headers = await authHeaders;

    final res = await client.post<AttendanceModel?>(
      Endpoints.initializeClassAttendance,
      headers: headers,
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
    final headers = await authHeaders;

    final res = await client.get<AttendanceRecordViewModel?>(
      Endpoints.getClassAttendanceRecordView,
      headers: headers,
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

  Future<ApiResponse<List<AttendanceClassModel>?>> getAllAttendances(
    DefaultQueryEntity query,
  ) async {
    final headers = await authHeaders;

    final queryParams = query.toQueryBuilder().build();

    final res = await client.get<List<AttendanceClassModel>?>(
      Endpoints.attendances,
      headers: headers,
      query: queryParams,
      parser: (data) {
        if (data is List) {
          return data
              .map(
                (e) => AttendanceClassModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    return res;
  }

  Future<ApiResponse<bool?>> deleteAttendance(String id) async {
    final headers = await authHeaders;

    final res = await client.delete<bool?>(
      Endpoints.deleteAttendance(id),
      headers: headers,
    );

    return res;
  }

  Future<ApiResponse<ExportedFileModel?>> exportAttendanceExcel(
    String id, {
    String? mode,
  }) async {
    final headers = await authHeaders;

    // Gắn query param (mode) nếu có
    final queryParams = <String, dynamic>{};
    if (mode != null) queryParams['mode'] = mode;

    final res = await client.get<ExportedFileModel?>(
      Endpoints.exportAttendanceExcel(id),
      headers: headers,
      query: queryParams,
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return ExportedFileModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    return res;
  }
}
