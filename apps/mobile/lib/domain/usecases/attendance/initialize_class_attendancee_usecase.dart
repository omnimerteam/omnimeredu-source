import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/attendance/attendance_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/attendance/attendance_repository.dart';

class InitializeClassAttendanceUseCase {
  final AttendanceRepository repository;

  InitializeClassAttendanceUseCase(this.repository);

  Future<ApiResponse<AttendanceEntity?>> call(
    AttendanceEntity attendanceData,
  ) async {
    return await repository.initializeClassAttendance(attendanceData);
  }
}
