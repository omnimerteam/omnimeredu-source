import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../repositories/auth_repository.dart';
import '../../entities/auth/register_user_entity.dart';
import '../../entities/auth/auth_user_entity.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<Either<Failure, AuthUserEntity>> call(RegisterUserEntity user) async {
    return await repository.registerUser(user);
  }
}
