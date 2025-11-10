import '../../../core/network/api_response.dart';
import '../../entities/tuition/extra_fee_entity.dart';
import '../../repositories/school/tuition/extra_fee_repository.dart';

/// UseCase: Lấy Extra Fee theo ID
class GetExtraFeeByIdUseCase {
  final ExtraFeeRepository repository;

  GetExtraFeeByIdUseCase(this.repository);

  Future<ApiResponse<ExtraFeeEntity?>> call(String id) async {
    return await repository.getExtraFeeById(id);
  }
}
