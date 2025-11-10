import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_response.dart';
import '../../../../../core/network/endpoints.dart';
import '../../../../../domain/entities/query/default_query_entity.dart';
import '../../../../models/tuition/discount_policy_model.dart';

/// DataSource chịu trách nhiệm gọi API Discount Policy
class DiscountPolicyRemoteDataSource {
  final ApiClient client;
  final Future<String?> Function() _getIdToken;

  DiscountPolicyRemoteDataSource({
    required this.client,
    required Future<String?> Function() getIdToken,
  }) : _getIdToken = getIdToken;

  // ---------------------------------------------------------------------------
  // 📘 LẤY DANH SÁCH DISCOUNT POLICY
  // ---------------------------------------------------------------------------
  Future<ApiResponse<List<DiscountPolicyModel>?>> getAllDiscountPolicies(
    DefaultQueryEntity query,
  ) async {
    try {
      final queryParams = query.toQueryBuilder().build();
      final token = await _getIdToken();

      final res = await client.get<List<DiscountPolicyModel>?>(
        Endpoints.discountPolicyList,
        headers: {if (token != null) "Authorization": "Bearer $token"},
        query: queryParams,
        parser: (data) {
          if (data is List) {
            return data
                .map(
                  (e) =>
                      DiscountPolicyModel.fromJson(e as Map<String, dynamic>),
                )
                .toList();
          }
          return null;
        },
      );

      return res;
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 📘 LẤY DISCOUNT POLICY THEO ID
  // ---------------------------------------------------------------------------
  Future<ApiResponse<DiscountPolicyModel?>> getDiscountPolicyById(
    String id,
  ) async {
    try {
      final token = await _getIdToken();
      final res = await client.get<DiscountPolicyModel?>(
        Endpoints.discountPolicyById(id),
        headers: {if (token != null) "Authorization": "Bearer $token"},
        parser: (data) {
          if (data is Map<String, dynamic>) {
            return DiscountPolicyModel.fromJson(data);
          }
          throw Exception("API không trả về dữ liệu hợp lệ");
        },
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 🟢 TẠO DISCOUNT POLICY
  // ---------------------------------------------------------------------------
  Future<ApiResponse<DiscountPolicyModel?>> createDiscountPolicy(
    DiscountPolicyModel data,
  ) async {
    try {
      final token = await _getIdToken();

      final res = await client.post<DiscountPolicyModel?>(
        Endpoints.createDiscountPolicy,
        headers: {if (token != null) "Authorization": "Bearer $token"},
        data: data.toJson(),
        parser: (data) {
          if (data is Map<String, dynamic>) {
            return DiscountPolicyModel.fromJson(data);
          }
          throw Exception("API không trả về dữ liệu hợp lệ");
        },
      );

      return res;
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 🟡 CẬP NHẬT DISCOUNT POLICY
  // ---------------------------------------------------------------------------
  Future<ApiResponse<DiscountPolicyModel?>> updateDiscountPolicy(
    DiscountPolicyModel data,
  ) async {
    try {
      if (data.id == null) {
        throw Exception("Chưa chọn được đối tượng để cập nhật");
      }

      final token = await _getIdToken();
      final res = await client.put<DiscountPolicyModel?>(
        Endpoints.updateDiscountPolicy(data.id!),
        headers: {if (token != null) "Authorization": "Bearer $token"},
        data: data.toJson(),
        parser: (data) {
          if (data is Map<String, dynamic>) {
            return DiscountPolicyModel.fromJson(data);
          }
          throw Exception("API không trả về dữ liệu hợp lệ");
        },
      );

      return res;
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 🔴 XOÁ DISCOUNT POLICY
  // ---------------------------------------------------------------------------
  Future<ApiResponse<void>> deleteDiscountPolicy(String id) async {
    try {
      if (id.isEmpty) {
        throw Exception("Chưa chọn được đối tượng để xóa");
      }

      final token = await _getIdToken();
      final res = await client.delete<void>(
        Endpoints.deleteDiscountPolicy(id),
        headers: {if (token != null) "Authorization": "Bearer $token"},
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
