import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/auth/role_entity.dart';
import '../../domain/repositories/role_repository.dart';
import '../datasources/remote/auth/role_remote_datasource.dart';

class RoleRepositoryImpl implements RoleRepository {
  final RoleRemoteDataSource remoteDataSource;

  RoleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<RoleEntity>>> getAllRoles() async {
    try {
      final models = await remoteDataSource.getAllRoles();
      return Right(models.map((e) => e.toEntity()).toList());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RoleEntity>>> getRolesPersonnel() async {
    try {
      final models = await remoteDataSource.getRolesPersonnel();
      return Right(models.map((e) => e.toEntity()).toList());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
