import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/tuition/extra_fee_entity.dart';

abstract class ExtraFeeRepository {
  Future<ApiResponse<List<ExtraFeeEntity>?>> getAllExtraFee(
    DefaultQueryEntity query,
  );

  Future<ApiResponse<ExtraFeeEntity?>> getExtraFeeById(String id);

  Future<ApiResponse<ExtraFeeEntity?>> createExtraFee(ExtraFeeEntity data);

  Future<ApiResponse<ExtraFeeEntity?>> updateExtraFee(ExtraFeeEntity data);

  Future<ApiResponse<void>> deleteExtraFee(String id);
}
