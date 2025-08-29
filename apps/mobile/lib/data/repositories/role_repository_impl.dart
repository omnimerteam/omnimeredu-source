import '../../domain/entities/role.dart';
import '../../domain/repositories/role_repository.dart';
import '../datasources/remote/role_remote_datasource.dart';

class RoleRepositoryImpl implements RoleRepository {
  final RoleRemoteDataSource remoteDataSource;

  RoleRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RoleEntity>> getAllRoles() async {
    final roles = await remoteDataSource.fetchRoles();
    // Lọc bỏ role SchoolAdmin
    return roles.where((role) => role.name != "SchoolAdmin").toList();
  }
}
