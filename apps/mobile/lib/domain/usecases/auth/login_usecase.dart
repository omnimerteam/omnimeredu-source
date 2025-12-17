import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/either.dart';
import '../../entities/auth/auth_user_entity.dart';
import '../../entities/auth/login_entity.dart';
import '../../repositories/auth/auth_repository.dart';

class LoginUseCase
    implements UseCase<Either<Failure, AuthUserEntity>, LoginEntity> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AuthUserEntity>> call(LoginEntity params) async {
    return await repository.login(params);
  }
}
