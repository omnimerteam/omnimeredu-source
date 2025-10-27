import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/tuition/extra_fee_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/tuition/extra_fee_repository.dart';

/// UseCase: Lấy Extra Fee theo ID
class GetExtraFeeByIdUseCase {
  final ExtraFeeRepository repository;

  GetExtraFeeByIdUseCase(this.repository);

  Future<ApiResponse<ExtraFeeEntity?>> call(String id) async {
    return await repository.getExtraFeeById(id);
  }
}
