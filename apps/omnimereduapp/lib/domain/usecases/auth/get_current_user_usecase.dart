import '../../entities/auth/auth_user_entity.dart';
import '../../repositories/auth/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<AuthUserEntity?> call() async {
    return await repository.getCurrentUser();
  }
}
