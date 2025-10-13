import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/data/models/tuition/extra_fee_model.dart';

/// DataSource chịu trách nhiệm gọi API Extra Fee
class ExtraFeeRemoteDataSource {
  final ApiClient client;
  final Future<String?> Function() _getIdToken;

  ExtraFeeRemoteDataSource({
    required this.client,
    required Future<String?> Function() getIdToken,
  }) : _getIdToken = getIdToken;

  // ---------------------------------------------------------------------------
  // 📘 LẤY DANH SÁCH EXTRA FEE
  // ---------------------------------------------------------------------------
  Future<ApiResponse<List<ExtraFeeModel>?>> getAllExtraFee(
    DefaultQueryEntity query,
  ) async {
    try {
      final queryParams = query.toQueryBuilder().build();

      final token = await _getIdToken();
      final res = await client.get<List<ExtraFeeModel>?>(
        Endpoints.extraFeeList,
        headers: {if (token != null) "Authorization": "Bearer $token"},
        query: queryParams,
        parser: (data) {
          if (data is List) {
            return data
                .map((e) => ExtraFeeModel.fromJson(e as Map<String, dynamic>))
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
  // 📘 LẤY EXTRA FEE THEO ID
  // ---------------------------------------------------------------------------
  Future<ApiResponse<ExtraFeeModel?>> getExtraFeeById(String id) async {
    try {
      final token = await _getIdToken();
      final res = await client.get<ExtraFeeModel?>(
        Endpoints.extraFeeById(id),
        headers: {if (token != null) "Authorization": "Bearer $token"},
        parser: (data) {
          if (data is Map<String, dynamic>) {
            return ExtraFeeModel.fromJson(data);
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
  // 🟢 TẠO EXTRA FEE
  // ---------------------------------------------------------------------------
  Future<ApiResponse<ExtraFeeModel?>> createExtraFee(ExtraFeeModel data) async {
    try {
      final token = await _getIdToken();

      final res = await client.post<ExtraFeeModel?>(
        Endpoints.createExtraFee,
        headers: {if (token != null) "Authorization": "Bearer $token"},
        data: data.toJson(),
        parser: (data) {
          if (data is Map<String, dynamic>) {
            return ExtraFeeModel.fromJson(data);
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
  // 🟡 CẬP NHẬT EXTRA FEE
  // ---------------------------------------------------------------------------
  Future<ApiResponse<ExtraFeeModel?>> updateExtraFee(ExtraFeeModel data) async {
    try {
      if (data.id != null || data.id == "") {
        throw new Exception("Chưa chọn được đối tượng để cập nhật");
      }

      final token = await _getIdToken();
      final res = await client.put<ExtraFeeModel?>(
        Endpoints.updateExtraFee(data.id!),
        headers: {if (token != null) "Authorization": "Bearer $token"},
        data: data.toJson(),
        parser: (data) {
          if (data is Map<String, dynamic>) {
            return ExtraFeeModel.fromJson(data);
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
  // 🔴 XOÁ EXTRA FEE
  // ---------------------------------------------------------------------------
  Future<ApiResponse<void>> deleteExtraFee(String id) async {
    try {
      if (id == "") {
        throw new Exception("Chưa chọn được đối tượng để xóa");
      }

      final token = await _getIdToken();
      final res = await client.delete<void>(
        Endpoints.deleteExtraFee(id),
        headers: {if (token != null) "Authorization": "Bearer $token"},
        parser: (_) => null,
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
