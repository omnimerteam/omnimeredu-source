import 'package:mobile/data/models/detail_record/detail_record_model.dart';
import 'package:mobile/data/models/detail_record/detail_record_student_model.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';

class DetailRecordRemoteDataSource {
  final ApiClient client;

  DetailRecordRemoteDataSource(this.client);

  /// Cập nhật trạng thái điểm danh cho học sinh
  Future<DetailRecordModel> updateStatusDetailRecord(
    DetailRecordModel data,
  ) async {
    if (data.id == null) {
      throw Exception("Hãy chọn bảng điểm danh để cập nhật");
    }

    final res = await client.patch<DetailRecordModel>(
      Endpoints.paymentAttendance.updateStatusDetailRecord(data.id!),
      data: data.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return DetailRecordModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(
        res.message.isNotEmpty ? res.message : "Cập nhật thất bại",
      );
    }
  }

  // Lấy danh sach các record của bảng điểm danh
  Future<List<DetailRecordStudentModel>> getAttendanceRecordsById(
    String attendanceId,
  ) async {
    final res = await client.get<List<DetailRecordStudentModel>>(
      Endpoints.paymentAttendance.getAttendanceRecordsById(attendanceId),
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
        return [];
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(
        res.message.isNotEmpty
            ? res.message
            : "Không thể tải danh sách điểm danh",
      );
    }
  }
}
