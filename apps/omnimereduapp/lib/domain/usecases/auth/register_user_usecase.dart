import '../../entities/auth/register_user_entity.dart';

import '../../repositories/auth/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repo;
  RegisterUserUseCase(this.repo);
  Future<void> call(RegisterUserEntity req) async {
    return await repo.register(req);
  }
}
