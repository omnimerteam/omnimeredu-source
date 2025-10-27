import '../../../core/error/failures.dart';

import '../../../domain/entities/auth/role_entity.dart';
import '../../../domain/repositories/auth/role_repository.dart';
import '../../datasources/remote/auth/role_remote_datasource.dart';

class RoleRepositoryImpl implements RoleRepository {
  final RoleRemoteDataSource remoteDataSource;

  RoleRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RoleEntity>> getAllRoles() async {
    try {
      final models = await remoteDataSource.getAllRoles();

      final entities = models.map((m) => m.toEntity()).toList();

      return entities;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<RoleEntity>> getRolesPersonnel() async {
    try {
      final models = await remoteDataSource.getRolesPersonnel();

      final entities = models.map((m) => m.toEntity()).toList();

      return entities;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
