import '../../../core/network/api_response.dart';
import '../../entities/attendance/attendance_entity.dart';
import '../../repositories/school/attendance/attendance_repository.dart';

class InitializeClassAttendanceUseCase {
  final AttendanceRepository repository;

  InitializeClassAttendanceUseCase(this.repository);

  Future<ApiResponse<AttendanceEntity?>> call(
    AttendanceEntity attendanceData,
  ) async {
    return await repository.initializeClassAttendance(attendanceData);
  }
}
