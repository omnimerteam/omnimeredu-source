import '../../../core/network/api_response.dart';
import '../../entities/tuition/extra_fee_entity.dart';
import '../../repositories/school/tuition/extra_fee_repository.dart';

/// UseCase: Cập nhật Extra Fee
class UpdateExtraFeeUseCase {
  final ExtraFeeRepository repository;

  UpdateExtraFeeUseCase(this.repository);

  Future<ApiResponse<ExtraFeeEntity?>> call(ExtraFeeEntity data) async {
    return await repository.updateExtraFee(data);
  }
}
