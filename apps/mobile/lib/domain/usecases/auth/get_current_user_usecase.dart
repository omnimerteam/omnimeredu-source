import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/either.dart';
import '../../entities/auth/auth_user_entity.dart';
import '../../repositories/auth/auth_repository.dart';

class GetCurrentUserUseCase
    implements UseCase<Either<Failure, AuthUserEntity?>, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, AuthUserEntity?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
