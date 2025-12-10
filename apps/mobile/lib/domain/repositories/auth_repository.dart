import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../entities/auth/auth_user_entity.dart';
import '../entities/auth/login_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUserEntity>> login(LoginEntity params);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser();
}
