import 'package:flutter_ios_android_platforms/core/error/failures.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/attendance/attendance_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/models/attendance/attendance_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/attendance/attendance_class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/attendance/attendance_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/view_model/attendance_record_view_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/attendance/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remote;

  AttendanceRepositoryImpl(this.remote);

  @override
  Future<ApiResponse<AttendanceEntity?>> initializeClassAttendance(
    AttendanceEntity attendanceDate,
  ) async {
    try {
      final model = await remote.initializeClassAttendance(
        AttendanceModel.fromEntity(attendanceDate),
      );
      return ApiResponse<AttendanceEntity?>(
        success: model.success,
        message: model.message,
        data: model.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure("Không thể khởi tạo điểm danh: $e");
    }
  }

  @override
  Future<ApiResponse<AttendanceRecordViewEntity?>> getClassAttendanceRecordView(
    DateTime date,
    String classId,
  ) async {
    try {
      final model = await remote.getClassAttendanceRecordView(date, classId);
      return ApiResponse<AttendanceRecordViewEntity?>(
        success: model.success,
        message: model.message,
        data: model.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure("Không thể khởi tạo điểm danh: $e");
    }
  }

  @override
  Future<ApiResponse<List<AttendanceClassEntity>?>> getAllAttendances(
    DefaultQueryEntity query,
  ) async {
    try {
      final model = await remote.getAllAttendances(query);
      return ApiResponse<List<AttendanceClassEntity>?>(
        success: model.success,
        message: model.message,
        data: model.data?.map((e) => e.toEntity()).toList(),
      );
    } catch (e) {
      throw ServerFailure("Không thể khởi tạo điểm danh: $e");
    }
  }

  @override
  Future<ApiResponse<bool?>> deleteAttendance(String id) async {
    try {
      final model = await remote.deleteAttendance(id);
      return ApiResponse<bool?>(
        success: model.success,
        message: model.message,
        data: model.data as bool,
      );
    } catch (e) {
      throw ServerFailure("Xóa điểm danh thất bại: ${e.toString()}");
    }
  }
}
