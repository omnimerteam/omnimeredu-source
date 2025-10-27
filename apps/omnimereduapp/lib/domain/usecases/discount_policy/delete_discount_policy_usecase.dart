import '../../../core/network/api_response.dart';
import '../../repositories/school/tuition/discount_policy_repository.dart';

/// UseCase: Xóa Discount Policy
class DeleteDiscountPolicyUseCase {
  final DiscountPolicyRepository repository;

  DeleteDiscountPolicyUseCase(this.repository);

  Future<ApiResponse<void>> call(String id) async {
    return await repository.deleteDiscountPolicy(id);
  }
}
