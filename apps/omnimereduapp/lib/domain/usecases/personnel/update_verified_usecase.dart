import '../../../core/network/api_response.dart';
import '../../repositories/user/personnel_repository.dart';

class UpdateVerifiedUseCase {
  final PersonnelRepository repository;

  UpdateVerifiedUseCase(this.repository);

  Future<ApiResponse<bool>> call(String personnelId, bool isVerified) async {
    return await repository.updateVerified(personnelId, isVerified);
  }
}
