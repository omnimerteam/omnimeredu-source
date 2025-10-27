import '../../../core/constants/enum_constant.dart';
import '../../../core/network/api_response.dart';
import '../../repositories/user/school_admin_repository.dart';

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
