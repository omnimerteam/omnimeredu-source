import '../../core/api/api_response.dart';
import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../entities/auth/auth_user_entity.dart';
import '../entities/auth/login_entity.dart';
import '../entities/auth/role_entity.dart';
import '../entities/auth/register_user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUserEntity>> login(LoginEntity params);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser();
  Future<ApiResponse<void>> changePassword(
    String oldPassword,
    String newPassword,
  );
  Future<Either<Failure, List<RoleEntity>>> getAllRoles();
  Future<Either<Failure, void>> registerUser(RegisterUserEntity user);
}
