import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/tuition/extra_fee_repository.dart';

/// UseCase: Xóa Extra Fee
class DeleteExtraFeeUseCase {
  final ExtraFeeRepository repository;

  DeleteExtraFeeUseCase(this.repository);

  Future<ApiResponse<void>> call(String id) async {
    return await repository.deleteExtraFee(id);
  }
}
