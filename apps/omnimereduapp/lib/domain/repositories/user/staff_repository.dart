import '../../../core/network/api_response.dart';
import '../../entities/user/staff_entity.dart';

abstract class StaffRepository {
  Future<ApiResponse<StaffEntity?>> updateStaff(StaffEntity updateStaffData);
}
