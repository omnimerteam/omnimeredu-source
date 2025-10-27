import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/school_admin_entity.dart';

abstract class SchoolAdminRepository {
  Future<ApiResponse<SchoolAdminPositionEnum>> updatePositionSchoolAdmin(
    String schoolAdminId,
    SchoolAdminPositionEnum position,
  );

  Future<ApiResponse<SchoolAdminEntity?>> updateSchoolAdmin(
    SchoolAdminEntity updateSchoolAdminData,
  );
}
