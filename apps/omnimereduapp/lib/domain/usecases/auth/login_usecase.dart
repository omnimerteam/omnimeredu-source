import '../../entities/auth/auth_user_entity.dart';
import '../../entities/auth/login_entity.dart';
import '../../repositories/auth/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Thực hiện login với LoginEntity
  Future<AuthUserEntity> call({required LoginEntity loginInfo}) async {
    return await repository.login(loginInfo: loginInfo);
  }
}
