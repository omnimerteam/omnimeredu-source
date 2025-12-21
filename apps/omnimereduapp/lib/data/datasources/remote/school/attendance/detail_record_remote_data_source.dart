import '../../../../../core/add_jwt.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_response.dart';
import '../../../../../core/network/endpoints.dart';
import '../../../../models/detail_record/detail_record_model.dart';
import '../../../../models/detail_record/detail_record_student_model.dart';
import '../../base_remote_data_source.dart';

class DetailRecordRemoteDataSource extends BaseRemoteDataSource {
  DetailRecordRemoteDataSource(ApiClient client, AppAuthProvider authProvider)
    : super(client, authProvider);

  /// Cập nhật trạng thái điểm danh cho học sinh
  Future<ApiResponse<DetailRecordModel?>> updateStatusDetailRecord(
    DetailRecordModel data,
  ) async {
    if (data.id == null) {
      throw Exception("Hãy chọn bảng điểm danh để cập nhật");
    }

    final headers = await authHeaders;

    final res = await client.patch<DetailRecordModel?>(
      Endpoints.updateStatusDetailRecord(data.id!),
      headers: headers,
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
    final headers = await authHeaders;

    final res = await client.get<List<DetailRecordStudentModel>?>(
      Endpoints.getAttendanceRecordsById(attendanceId),
      headers: headers,
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
