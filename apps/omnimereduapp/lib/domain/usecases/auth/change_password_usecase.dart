import '../../../core/network/api_response.dart';
import '../../repositories/auth/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repo;
  ChangePasswordUseCase(this.repo);
  Future<ApiResponse<void>> call(String oldPassword, String newPassword) async {
    return await repo.changePassword(oldPassword, newPassword);
  }
}
