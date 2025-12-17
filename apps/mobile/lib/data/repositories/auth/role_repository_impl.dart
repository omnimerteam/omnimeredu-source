import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/utils/either.dart';
import 'package:mobile/core/utils/api_utils.dart';
import 'package:mobile/domain/entities/auth/role_entity.dart';
import 'package:mobile/domain/repositories/auth/role_repository.dart';
import 'package:mobile/data/datasources/remote/auth/role_remote_datasource.dart';

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
