import '../../../core/network/api_response.dart';
import '../../entities/detail_record/detail_record_student_entity.dart';
import '../../repositories/school/attendance/detail_record_repository.dart';

class GetAttendanceRecordByIdUseCase {
  final DetailRecordRepository repository;

  GetAttendanceRecordByIdUseCase(this.repository);

  Future<ApiResponse<List<DetailRecordStudentEntity>?>>
  getAttendanceRecordsById(String attendanceId) async {
    return await repository.getAttendanceRecordsById(attendanceId);
  }
}
