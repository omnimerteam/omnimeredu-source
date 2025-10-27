import '../../../core/network/api_response.dart';
import '../../entities/user/base_user_entity.dart';
import '../../repositories/auth/auth_repository.dart';

class GetUserProfileByIdUseCase {
  final AuthRepository repo;
  GetUserProfileByIdUseCase(this.repo);
  Future<ApiResponse<BaseUserEntity>> getUserProfileById(String userId) async {
    return await repo.getUserProfileById(userId);
  }
}
