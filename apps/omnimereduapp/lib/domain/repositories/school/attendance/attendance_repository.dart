import '../../../../core/network/api_response.dart';
import '../../../entities/attendance/attendance_class_entity.dart';
import '../../../entities/attendance/attendance_entity.dart';
import '../../../entities/query/default_query_entity.dart';
import '../../../entities/view_model/attendance_record_view_entity.dart';

abstract class AttendanceRepository {
  Future<ApiResponse<AttendanceEntity?>> initializeClassAttendance(
    AttendanceEntity attendanceDate,
  );

  Future<ApiResponse<AttendanceRecordViewEntity?>> getClassAttendanceRecordView(
    DateTime date,
    String classId,
  );

  Future<ApiResponse<List<AttendanceClassEntity>?>> getAllAttendances(
    DefaultQueryEntity query,
  );

  Future<ApiResponse<bool?>> deleteAttendance(String id);

  // Future<ApiResponse<>>
}
