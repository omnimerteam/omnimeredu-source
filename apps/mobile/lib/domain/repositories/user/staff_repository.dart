import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/staff_entity.dart';

abstract class StaffRepository {
  Future<ApiResponse<StaffEntity?>> updateStaff(StaffEntity updateStaffData);
}
