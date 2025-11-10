import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response.dart';
import '../../../datasources/remote/school/attendance/detail_record_remote_data_source.dart';
import '../../../models/detail_record/detail_record_model.dart';
import '../../../../domain/entities/detail_record/detail_record_entity.dart';
import '../../../../domain/entities/detail_record/detail_record_student_entity.dart';
import '../../../../domain/repositories/school/attendance/detail_record_repository.dart';

class DetailRecordRepositoryImpl implements DetailRecordRepository {
  final DetailRecordRemoteDataSource remote;

  DetailRecordRepositoryImpl(this.remote);

  @override
  Future<ApiResponse<DetailRecordEntity?>> updateStatusDetailRecord(
    DetailRecordEntity data,
  ) async {
    try {
      final model = await remote.updateStatusDetailRecord(
        DetailRecordModel.fromEntity(data),
      );
      return ApiResponse<DetailRecordEntity?>(
        success: model.success,
        message: model.message,
        data: model.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ApiResponse<List<DetailRecordStudentEntity>?>>
  getAttendanceRecordsById(String attendanceId) async {
    try {
      final model = await remote.getAttendanceRecordsById(attendanceId);
      return ApiResponse<List<DetailRecordStudentEntity>?>(
        success: model.success,
        message: model.message,
        data: model.data != null
            ? model.data?.map((e) => e.toEntity()).toList()
            : [],
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
