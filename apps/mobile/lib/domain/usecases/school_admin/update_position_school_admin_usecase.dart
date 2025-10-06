import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/school_admin_repository.dart';

class UpdatePositionSchoolAdminUseCase {
  final SchoolAdminRepository repository;

  UpdatePositionSchoolAdminUseCase(this.repository);

  Future<ApiResponse<SchoolAdminPositionEnum>> call(
    String schoolAdminId,
    SchoolAdminPositionEnum position,
  ) async {
    return await repository.updatePositionSchoolAdmin(schoolAdminId, position);
  }
}
