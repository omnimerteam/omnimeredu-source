import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/detail_record/detail_record_entity.dart';
import '../../entities/detail_record/detail_record_student_entity.dart';

abstract class DetailRecordRepository {
  Future<Either<Failure, DetailRecordEntity?>> updateStatusDetailRecord(
    DetailRecordEntity data,
  );

  Future<Either<Failure, List<DetailRecordStudentEntity>?>>
  getAttendanceRecordsById(String attendanceId);
}
