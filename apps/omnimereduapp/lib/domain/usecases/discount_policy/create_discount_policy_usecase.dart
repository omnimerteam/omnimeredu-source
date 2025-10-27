import '../../../core/network/api_response.dart';
import '../../entities/tuition/discount_policy_entity.dart';
import '../../repositories/school/tuition/discount_policy_repository.dart';

/// UseCase: Tạo mới Discount Policy
class CreateDiscountPolicyUseCase {
  final DiscountPolicyRepository repository;

  CreateDiscountPolicyUseCase(this.repository);

  Future<ApiResponse<DiscountPolicyEntity?>> call(
    DiscountPolicyEntity data,
  ) async {
    return await repository.createDiscountPolicy(data);
  }
}
