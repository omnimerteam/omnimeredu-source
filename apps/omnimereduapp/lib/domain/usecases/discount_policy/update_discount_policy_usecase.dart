import '../../../core/network/api_response.dart';
import '../../entities/tuition/discount_policy_entity.dart';
import '../../repositories/school/tuition/discount_policy_repository.dart';

/// UseCase: Cập nhật Discount Policy
class UpdateDiscountPolicyUseCase {
  final DiscountPolicyRepository repository;

  UpdateDiscountPolicyUseCase(this.repository);

  Future<ApiResponse<DiscountPolicyEntity?>> call(
    DiscountPolicyEntity data,
  ) async {
    return await repository.updateDiscountPolicy(data);
  }
}
