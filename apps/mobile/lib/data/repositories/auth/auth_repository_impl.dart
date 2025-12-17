import '../../../core/error/failures.dart'; // Needed for type
import '../../../core/utils/either.dart'; // Needed for type
import '../../../core/utils/api_utils.dart'; // Import safeApiCall
import '../../../domain/entities/auth/auth_user_entity.dart';
import '../../../domain/entities/auth/login_entity.dart';
import '../../../domain/entities/auth/register_user_entity.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import '../../datasources/remote/auth/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthUserEntity>> login(LoginEntity params) async {
    return safeApiCall(() async {
      final model = await remoteDataSource.login(params);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return safeApiCall(() async {
      await remoteDataSource.logout();
    });
  }

  @override
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser() async {
    return safeApiCall(() async {
      final model = await remoteDataSource.getCurrentUser();
      return model?.toEntity();
    });
  }

  @override
  Future<Either<Failure, AuthUserEntity>> registerUser(
    RegisterUserEntity user,
  ) async {
    return safeApiCall(() async {
      final model = await remoteDataSource.registerUser(user);
      return model.toEntity();
    });
  }
}
