import '../../core/api/api_response.dart';
import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../core/constants/enum_constant.dart';
import '../../domain/entities/auth/auth_user_entity.dart';
import '../../domain/entities/auth/login_entity.dart';
import '../../domain/entities/auth/register_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthUserEntity>> login(LoginEntity params) async {
    try {
      final model = await remoteDataSource.login(params);
      return Right(model.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser() async {
    try {
      // TODO: Remove mock data implementation when backend is ready
      if (_isMockMode) {
        // For now, return null (user not logged in)
        // In a real implementation, this would check stored tokens
        return const Right(null);
      }

      final model = await remoteDataSource.getCurrentUser();
      return Right(model?.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(RegisterUserEntity user) async {
    try {
      await remoteDataSource.registerUser(user);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
