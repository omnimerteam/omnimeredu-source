import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../../core/utils/api_utils.dart';
import '../../../domain/entities/auth/role_entity.dart';
import '../../../domain/repositories/auth/role_repository.dart';
import '../../datasources/remote/auth/role_remote_datasource.dart';

class RoleRepositoryImpl implements RoleRepository {
  final RoleRemoteDataSource remoteDataSource;

  RoleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<RoleEntity>>> getAllRoles() async {
    return safeApiCall(() async {
      final models = await remoteDataSource.getAllRoles();
      return models.map((e) => e.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<RoleEntity>>> getRolesPersonnel() async {
    return safeApiCall(() async {
      final models = await remoteDataSource.getRolesPersonnel();
      return models.map((e) => e.toEntity()).toList();
    });
  }
}
