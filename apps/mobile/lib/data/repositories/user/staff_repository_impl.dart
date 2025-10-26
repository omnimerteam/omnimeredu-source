import 'package:flutter_ios_android_platforms/core/error/failures.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/user/staff_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/models/user/staff_mode.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/staff_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/staff_repository.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffRemoteDataSource remote;

  StaffRepositoryImpl(this.remote);

  @override
  Future<ApiResponse<StaffEntity?>> updateStaff(
    StaffEntity updateStaffData,
  ) async {
    try {
      final model = StaffModel.fromEntity(updateStaffData);
      final res = await remote.updateStaff(model);

      // ✅ Trả về ApiResponse cùng cấu trúc, convert sang Entity
      return ApiResponse<StaffEntity?>(
        success: res.success,
        message: res.message,
        data: res.data?.toEntity(),
      );
    } on ServerFailure catch (e) {
      // ✅ Nếu lỗi từ tầng dưới đã được wrap sẵn
      return ApiResponse<StaffEntity?>(
        success: false,
        message: e.message,
        data: null,
      );
    } catch (e) {
      // ✅ Bắt mọi lỗi runtime khác, tránh throw ra ngoài không kiểm soát
      return ApiResponse<StaffEntity?>(
        success: false,
        message: "Không thể cập nhật nhân viên trường: ${e.toString()}",
        data: null,
      );
    }
  }
}
