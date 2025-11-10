import '../../../../core/network/api_response.dart';
import '../../../entities/query/default_query_entity.dart';
import '../../../entities/tuition/discount_policy_entity.dart';

/// Interface chuẩn cho tầng Domain
/// - Định nghĩa contract các thao tác CRUD với Discount Policy
abstract class DiscountPolicyRepository {
  Future<ApiResponse<List<DiscountPolicyEntity>?>> getAllDiscountPolicies(
    DefaultQueryEntity query,
  );

  Future<ApiResponse<DiscountPolicyEntity?>> getDiscountPolicyById(String id);

  Future<ApiResponse<DiscountPolicyEntity?>> createDiscountPolicy(
    DiscountPolicyEntity data,
  );

  Future<ApiResponse<DiscountPolicyEntity?>> updateDiscountPolicy(
    DiscountPolicyEntity data,
  );

  Future<ApiResponse<void>> deleteDiscountPolicy(String id);
}
