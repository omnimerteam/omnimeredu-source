import '../../../core/constants/enum_constant.dart';
import '../../../core/network/api_response.dart';
import '../../entities/user/school_admin_entity.dart';

abstract class SchoolAdminRepository {
  Future<ApiResponse<SchoolAdminPositionEnum>> updatePositionSchoolAdmin(
    String schoolAdminId,
    SchoolAdminPositionEnum position,
  );

  Future<ApiResponse<SchoolAdminEntity?>> updateSchoolAdmin(
    SchoolAdminEntity updateSchoolAdminData,
  );
}
