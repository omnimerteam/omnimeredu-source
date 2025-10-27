import '../../../core/network/api_response.dart';
import '../../entities/query/default_query_entity.dart';
import '../../entities/tuition/extra_fee_entity.dart';
import '../../repositories/school/tuition/extra_fee_repository.dart';

/// UseCase: Lấy toàn bộ danh sách Extra Fee
class GetAllExtraFeeUseCase {
  final ExtraFeeRepository repository;

  GetAllExtraFeeUseCase(this.repository);

  Future<ApiResponse<List<ExtraFeeEntity>?>> call(
    DefaultQueryEntity query,
  ) async {
    return await repository.getAllExtraFee(query);
  }
}
