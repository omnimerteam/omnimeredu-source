import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/tuition/discount_policy_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/tuition/discount_policy_repository.dart';

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
