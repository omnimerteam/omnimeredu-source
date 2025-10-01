import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/attendance/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<ApiResponse<AttendanceEntity?>> initializeClassAttendance(
    AttendanceEntity attendanceDate,
  );
}
