import '../../../core/network/api_response.dart';
import '../../entities/tuition/discount_policy_entity.dart';
import '../../repositories/school/tuition/discount_policy_repository.dart';

/// UseCase: Lấy Discount Policy theo ID
class GetDiscountPolicyByIdUseCase {
  final DiscountPolicyRepository repository;

  GetDiscountPolicyByIdUseCase(this.repository);

  Future<ApiResponse<DiscountPolicyEntity?>> call(String id) async {
    return await repository.getDiscountPolicyById(id);
  }
}
