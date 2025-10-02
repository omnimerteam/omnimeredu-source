import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/detail_record/detail_record_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/attendance/detail_record_repository.dart';

class UpdateStatusDetailRecordUseCase {
  final DetailRecordRepository repository;

  UpdateStatusDetailRecordUseCase(this.repository);

  Future<ApiResponse<DetailRecordEntity?>> call(DetailRecordEntity data) async {
    return await repository.updateStatusDetailRecord(data);
  }
}
