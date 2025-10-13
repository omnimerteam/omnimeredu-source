import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/tuition/discount_policy_repository.dart';

/// UseCase: Xóa Discount Policy
class DeleteDiscountPolicyUseCase {
  final DiscountPolicyRepository repository;

  DeleteDiscountPolicyUseCase(this.repository);

  Future<ApiResponse<void>> call(String id) async {
    return await repository.deleteDiscountPolicy(id);
  }
}
