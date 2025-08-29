import '../entities/role.dart';

abstract class RoleRepository {
  Future<List<RoleEntity>> getAllRoles();
}
