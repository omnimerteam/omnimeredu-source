import '../../../domain/entities/auth/role.dart';
import '../../../domain/repositories/auth/role_repository.dart';
import '../../datasources/remote/auth/role_remote_datasource.dart';

class RoleRepositoryImpl implements RoleRepository {
  final RoleRemoteDataSource remoteDataSource;

  RoleRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RoleEntity>> getAllRoles() async {
    final models = await remoteDataSource.fetchRoles();

    final entities = models.map((m) => m.toEntity()).toList();

    return entities;
  }
}
