import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/utils/either.dart';
import 'package:mobile/domain/entities/auth/auth_user_entity.dart';
import 'package:mobile/domain/entities/auth/login_entity.dart';
import 'package:mobile/domain/entities/auth/register_user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUserEntity>> login(LoginEntity params);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser();
  Future<Either<Failure, AuthUserEntity>> registerUser(RegisterUserEntity user);
}
