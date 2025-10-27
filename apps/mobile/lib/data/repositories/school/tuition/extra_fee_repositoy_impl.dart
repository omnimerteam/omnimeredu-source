import 'package:flutter_ios_android_platforms/core/error/failures.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/tuition/extra_fee_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/models/tuition/extra_fee_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/tuition/extra_fee_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/tuition/extra_fee_repository.dart';

/// Repository triển khai logic tầng dữ liệu cho Extra Fee
/// - Chịu trách nhiệm chuyển đổi giữa Model và Entity
/// - Gói lỗi dưới dạng [ServerFailure]
/// - Giữ logic nghiệp vụ ở Domain sạch và ổn định
class ExtraFeeRepositoryImpl implements ExtraFeeRepository {
  final ExtraFeeRemoteDataSource remote;

  ExtraFeeRepositoryImpl(this.remote);

  // ---------------------------------------------------------------------------
  // 📘 LẤY DANH SÁCH EXTRA FEE
  // ---------------------------------------------------------------------------
  @override
  Future<ApiResponse<List<ExtraFeeEntity>?>> getAllExtraFee(
    DefaultQueryEntity query,
  ) async {
    try {
      final modelRes = await remote.getAllExtraFee(query);
      return ApiResponse<List<ExtraFeeEntity>?>(
        success: modelRes.success,
        message: modelRes.message,
        data: modelRes.data?.map((m) => m.toEntity()).toList(),
      );
    } catch (e) {
      throw ServerFailure("Không thể tải danh sách Extra Fee: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // 📘 LẤY EXTRA FEE THEO ID
  // ---------------------------------------------------------------------------
  @override
  Future<ApiResponse<ExtraFeeEntity?>> getExtraFeeById(String id) async {
    try {
      final modelRes = await remote.getExtraFeeById(id);
      return ApiResponse<ExtraFeeEntity?>(
        success: modelRes.success,
        message: modelRes.message,
        data: modelRes.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure("Không thể tải Extra Fee theo ID: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // 🟢 TẠO EXTRA FEE
  // ---------------------------------------------------------------------------
  @override
  Future<ApiResponse<ExtraFeeEntity?>> createExtraFee(
    ExtraFeeEntity data,
  ) async {
    try {
      final modelRes = await remote.createExtraFee(
        ExtraFeeModel.fromEntity(data),
      );
      return ApiResponse<ExtraFeeEntity?>(
        success: modelRes.success,
        message: modelRes.message,
        data: modelRes.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure("Không thể tạo Extra Fee: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // 🟡 CẬP NHẬT EXTRA FEE
  // ---------------------------------------------------------------------------
  @override
  Future<ApiResponse<ExtraFeeEntity?>> updateExtraFee(
    ExtraFeeEntity data,
  ) async {
    try {
      final modelRes = await remote.updateExtraFee(
        ExtraFeeModel.fromEntity(data),
      );
      return ApiResponse<ExtraFeeEntity?>(
        success: modelRes.success,
        message: modelRes.message,
        data: modelRes.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure("Không thể cập nhật Extra Fee: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // 🔴 XOÁ EXTRA FEE
  // ---------------------------------------------------------------------------
  @override
  Future<ApiResponse<void>> deleteExtraFee(String id) async {
    try {
      final modelRes = await remote.deleteExtraFee(id);
      return ApiResponse<void>(
        success: modelRes.success,
        message: modelRes.message,
        data: null,
      );
    } catch (e) {
      throw ServerFailure("Không thể xóa Extra Fee: $e");
    }
  }
}
