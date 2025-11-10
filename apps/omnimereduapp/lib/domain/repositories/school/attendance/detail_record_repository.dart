import '../../../../core/network/api_response.dart';
import '../../../entities/detail_record/detail_record_entity.dart';
import '../../../entities/detail_record/detail_record_student_entity.dart';

abstract class DetailRecordRepository {
  Future<ApiResponse<DetailRecordEntity?>> updateStatusDetailRecord(
    DetailRecordEntity data,
  );

  Future<ApiResponse<List<DetailRecordStudentEntity>?>>
  getAttendanceRecordsById(String attendanceId);
}
