import '../../entities/auth/role_entity.dart';

abstract class RoleRepository {
  Future<List<RoleEntity>> getAllRoles();

  Future<List<RoleEntity>> getRolesPersonnel();
}
