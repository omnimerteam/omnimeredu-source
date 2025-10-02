import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/detail_record/detail_record_entity.dart';

abstract class DetailRecordRepository {
  Future<ApiResponse<DetailRecordEntity?>> updateStatusDetailRecord(
    DetailRecordEntity data,
  );
}
