import '../../../core/network/api_response.dart';
import '../../entities/query/default_query_entity.dart';
import '../../entities/tuition/discount_policy_entity.dart';
import '../../repositories/school/tuition/discount_policy_repository.dart';

/// UseCase: Lấy danh sách tất cả Discount Policy
class GetAllDiscountPoliciesUseCase {
  final DiscountPolicyRepository repository;

  GetAllDiscountPoliciesUseCase(this.repository);

  Future<ApiResponse<List<DiscountPolicyEntity>?>> call(
    DefaultQueryEntity query,
  ) async {
    return await repository.getAllDiscountPolicies(query);
  }
}
