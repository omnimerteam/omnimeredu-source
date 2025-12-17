import 'package:mobile/data/models/attendance/export_file_model.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';
import '../../../models/attendance/attendance_class_model.dart';
import '../../../models/attendance/attendance_model.dart';
import '../../../models/view_model/attendance_record_model.dart';
import '../../../../domain/entities/query/default_query_entity.dart';

class AttendanceRemoteDataSource {
  final ApiClient client;

  AttendanceRemoteDataSource(this.client);

  /// 🔹 Tạo teaching assignment
  Future<AttendanceModel> initializeClassAttendance(
    AttendanceModel assignment,
  ) async {
    final res = await client.post<AttendanceModel>(
      Endpoints.paymentAttendance.initializeClassAttendance,
      data: assignment.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return AttendanceModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(
        res.message.isNotEmpty ? res.message : "Không thể khởi tạo điểm danh",
      );
    }
  }

  Future<AttendanceRecordViewModel> getClassAttendanceRecordView(
    DateTime date,
    String classId,
  ) async {
    final res = await client.get<AttendanceRecordViewModel>(
      Endpoints.paymentAttendance.getClassAttendanceRecordView,
      query: {"date": date.toUtc().toIso8601String(), "classId": classId},
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return AttendanceRecordViewModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(
        res.message.isNotEmpty
            ? res.message
            : "Không thể lấy thông tin điểm danh",
      );
    }
  }

  Future<List<AttendanceClassModel>> getAllAttendances(
    DefaultQueryEntity query,
  ) async {
    final queryParams = query.toQueryBuilder().build();

    final res = await client.get<List<AttendanceClassModel>>(
      Endpoints.paymentAttendance.attendances,
      query: queryParams,
      parser: (data) {
        if (data is List) {
          return data
              .map(
                (e) => AttendanceClassModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
        return [];
      },
    );

    if (res.success) {
      return res.data ?? [];
    } else {
      throw Exception(
        res.message.isNotEmpty
            ? res.message
            : "Không thể lấy danh sách điểm danh",
      );
    }
  }

  Future<bool> deleteAttendance(String id) async {
    final res = await client.delete<bool>(
      Endpoints.paymentAttendance.attendanceById(id),
    );

    if (res.success) {
      return true;
    } else {
      throw Exception(
        res.message.isNotEmpty ? res.message : "Xóa điểm danh thất bại",
      );
    }
  }

  Future<ExportedFileModel> exportAttendanceExcel(
    String id, {
    String? mode,
  }) async {
    // Gắn query param (mode) nếu có
    final queryParams = <String, dynamic>{};
    if (mode != null) queryParams['mode'] = mode;

    final res = await client.get<ExportedFileModel>(
      Endpoints.paymentAttendance.exportAttendanceExcel(id),
      query: queryParams,
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return ExportedFileModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(
        res.message.isNotEmpty ? res.message : "Xuất file thất bại",
      );
    }
  }
}
