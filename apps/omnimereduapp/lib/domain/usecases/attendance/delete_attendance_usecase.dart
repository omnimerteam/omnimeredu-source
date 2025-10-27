import '../../../core/network/api_response.dart';
import '../../repositories/school/attendance/attendance_repository.dart';

class DeleteAttendanceUseCase {
  final AttendanceRepository repository;

  DeleteAttendanceUseCase(this.repository);

  Future<ApiResponse<bool?>> call(String id) async {
    return await repository.deleteAttendance(id);
  }
}
