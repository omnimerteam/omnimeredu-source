import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/either.dart';
import '../../repositories/auth_repository.dart';
import '../../entities/auth/register_user_entity.dart';
import '../../entities/auth/auth_user_entity.dart';

class RegisterUserUseCase
    implements UseCase<Either<Failure, AuthUserEntity>, RegisterUserEntity> {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  @override
  Future<Either<Failure, AuthUserEntity>> call(
    RegisterUserEntity params,
  ) async {
    return await repository.registerUser(params);
  }
}
