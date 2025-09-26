import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/core/error/failures.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/user/school_admin_remote_data_source.dart';

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
}
