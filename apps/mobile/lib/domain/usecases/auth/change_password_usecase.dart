import '../../../core/api/api_response.dart';
import '../../repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<ApiResponse<void>> call(String oldPassword, String newPassword) async {
    return await repository.changePassword(oldPassword, newPassword);
  }
}
