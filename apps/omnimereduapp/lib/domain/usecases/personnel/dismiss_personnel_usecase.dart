import '../../../core/network/api_response.dart';
import '../../repositories/user/personnel_repository.dart';

class DismissPersonnelUseCase {
  final PersonnelRepository repository;

  DismissPersonnelUseCase(this.repository);

  Future<ApiResponse<void>> call(String personnelId) async {
    return await repository.dismissPersonnel(personnelId);
  }
}
