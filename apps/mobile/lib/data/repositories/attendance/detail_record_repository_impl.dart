import 'package:mobile/data/datasources/remote/attendance/detail_record_remote_data_source.dart';
import 'package:mobile/data/models/detail_record/detail_record_model.dart';
import 'package:mobile/domain/repositories/attendance/detail_record_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/api_utils.dart';
import '../../../../core/utils/either.dart';
import '../../../../domain/entities/detail_record/detail_record_entity.dart';
import '../../../../domain/entities/detail_record/detail_record_student_entity.dart';

class DetailRecordRepositoryImpl implements DetailRecordRepository {
  final DetailRecordRemoteDataSource remote;

  DetailRecordRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, DetailRecordEntity?>> updateStatusDetailRecord(
    DetailRecordEntity data,
  ) async {
    return safeApiCall(() async {
      final model = await remote.updateStatusDetailRecord(
        DetailRecordModel.fromEntity(data),
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, List<DetailRecordStudentEntity>?>>
  getAttendanceRecordsById(String attendanceId) async {
    return safeApiCall(() async {
      final models = await remote.getAttendanceRecordsById(attendanceId);
      return models.map((e) => e.toEntity()).toList();
    });
  }
}
