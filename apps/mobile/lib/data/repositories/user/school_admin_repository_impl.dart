import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/core/error/failures.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/user/school_admin_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/models/user/school_admin_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/school_admin_entity.dart';

import 'package:flutter_ios_android_platforms/domain/repositories/user/school_admin_repository.dart';

class SchoolAdminRepositoryImpl implements SchoolAdminRepository {
  final SchoolAdminRemoteDataSource remote;

  SchoolAdminRepositoryImpl(this.remote);

  @override
  Future<ApiResponse<SchoolAdminPositionEnum>> updatePositionSchoolAdmin(
    String schoolAdminId,
    SchoolAdminPositionEnum position,
  ) async {
    try {
      final res = await remote.updatePositionSchoolAdmin(
        schoolAdminId,
        position,
      );
      return ApiResponse<SchoolAdminPositionEnum>(
        success: res.success,
        message: res.message,
        data: res.data,
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ApiResponse<SchoolAdminEntity?>> updateSchoolAdmin(
    SchoolAdminEntity updateSchoolAdminData,
  ) async {
    try {
      final model = SchoolAdminModel.fromEntity(updateSchoolAdminData);
      final res = await remote.updateSchoolAdmin(model);

      // ✅ Trả về ApiResponse cùng cấu trúc, convert sang Entity
      return ApiResponse<SchoolAdminEntity?>(
        success: res.success,
        message: res.message,
        data: res.data?.toEntity(),
      );
    } on ServerFailure catch (e) {
      // ✅ Nếu lỗi từ tầng dưới đã được wrap sẵn
      return ApiResponse<SchoolAdminEntity?>(
        success: false,
        message: e.message,
        data: null,
      );
    } catch (e) {
      // ✅ Bắt mọi lỗi runtime khác, tránh throw ra ngoài không kiểm soát
      return ApiResponse<SchoolAdminEntity?>(
        success: false,
        message: "Không thể cập nhật viên quản lý trường: ${e.toString()}",
        data: null,
      );
    }
  }
}
