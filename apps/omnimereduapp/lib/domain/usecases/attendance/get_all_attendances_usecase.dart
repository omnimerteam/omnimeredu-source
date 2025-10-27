import '../../../core/network/api_response.dart';
import '../../entities/attendance/attendance_class_entity.dart';
import '../../entities/query/default_query_entity.dart';
import '../../repositories/school/attendance/attendance_repository.dart';

class GetAllAttendancesUseCase {
  final AttendanceRepository repository;

  GetAllAttendancesUseCase(this.repository);

  Future<ApiResponse<List<AttendanceClassEntity>?>> call(
    DefaultQueryEntity query,
  ) async {
    return await repository.getAllAttendances(query);
  }
}
