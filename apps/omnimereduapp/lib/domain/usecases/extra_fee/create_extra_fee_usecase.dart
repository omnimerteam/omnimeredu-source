import '../../../core/network/api_response.dart';
import '../../entities/tuition/extra_fee_entity.dart';
import '../../repositories/school/tuition/extra_fee_repository.dart';

/// UseCase: Tạo mới một Extra Fee
class CreateExtraFeeUseCase {
  final ExtraFeeRepository repository;

  CreateExtraFeeUseCase(this.repository);

  Future<ApiResponse<ExtraFeeEntity?>> call(ExtraFeeEntity data) async {
    return await repository.createExtraFee(data);
  }
}
