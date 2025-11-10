import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response.dart';
import '../../../datasources/remote/school/tuition/discount_policy_remote_data_source.dart';
import '../../../models/tuition/discount_policy_model.dart';
import '../../../../domain/entities/query/default_query_entity.dart';
import '../../../../domain/entities/tuition/discount_policy_entity.dart';
import '../../../../domain/repositories/school/tuition/discount_policy_repository.dart';

/// Repository triển khai logic tầng dữ liệu cho Discount Policy
/// - Chịu trách nhiệm chuyển đổi giữa Model và Entity
/// - Gói lỗi dưới dạng [ServerFailure]
/// - Giữ logic nghiệp vụ ở Domain sạch và ổn định
class DiscountPolicyRepositoryImpl implements DiscountPolicyRepository {
  final DiscountPolicyRemoteDataSource remote;

  DiscountPolicyRepositoryImpl(this.remote);

  // ---------------------------------------------------------------------------
  // 📘 LẤY DANH SÁCH DISCOUNT POLICY
  // ---------------------------------------------------------------------------
  @override
  Future<ApiResponse<List<DiscountPolicyEntity>?>> getAllDiscountPolicies(
    DefaultQueryEntity query,
  ) async {
    try {
      final modelRes = await remote.getAllDiscountPolicies(query);
      return ApiResponse<List<DiscountPolicyEntity>?>(
        success: modelRes.success,
        message: modelRes.message,
        data: modelRes.data?.map((m) => m.toEntity()).toList(),
      );
    } catch (e) {
      throw ServerFailure("Không thể tải danh sách Discount Policy: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // 📘 LẤY DISCOUNT POLICY THEO ID
  // ---------------------------------------------------------------------------
  @override
  Future<ApiResponse<DiscountPolicyEntity?>> getDiscountPolicyById(
    String id,
  ) async {
    try {
      final modelRes = await remote.getDiscountPolicyById(id);
      return ApiResponse<DiscountPolicyEntity?>(
        success: modelRes.success,
        message: modelRes.message,
        data: modelRes.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure("Không thể tải Discount Policy theo ID: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // 🟢 TẠO DISCOUNT POLICY
  // ---------------------------------------------------------------------------
  @override
  Future<ApiResponse<DiscountPolicyEntity?>> createDiscountPolicy(
    DiscountPolicyEntity data,
  ) async {
    try {
      final modelRes = await remote.createDiscountPolicy(
        DiscountPolicyModel.fromEntity(data),
      );
      return ApiResponse<DiscountPolicyEntity?>(
        success: modelRes.success,
        message: modelRes.message,
        data: modelRes.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure("Không thể tạo Discount Policy: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // 🟡 CẬP NHẬT DISCOUNT POLICY
  // ---------------------------------------------------------------------------
  @override
  Future<ApiResponse<DiscountPolicyEntity?>> updateDiscountPolicy(
    DiscountPolicyEntity data,
  ) async {
    try {
      final modelRes = await remote.updateDiscountPolicy(
        DiscountPolicyModel.fromEntity(data),
      );
      return ApiResponse<DiscountPolicyEntity?>(
        success: modelRes.success,
        message: modelRes.message,
        data: modelRes.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure("Không thể cập nhật Discount Policy: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // 🔴 XOÁ DISCOUNT POLICY
  // ---------------------------------------------------------------------------
  @override
  Future<ApiResponse<void>> deleteDiscountPolicy(String id) async {
    try {
      final modelRes = await remote.deleteDiscountPolicy(id);
      return ApiResponse<void>(
        success: modelRes.success,
        message: modelRes.message,
        data: null,
      );
    } catch (e) {
      throw ServerFailure("Không thể xóa Discount Policy: $e");
    }
  }
}
