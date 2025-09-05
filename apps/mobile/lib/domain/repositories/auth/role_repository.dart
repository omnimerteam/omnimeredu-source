import '../../entities/auth/role.dart';

abstract class RoleRepository {
  Future<List<RoleEntity>> getAllRoles();
}
