import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../entities/auth/role_entity.dart';

abstract class RoleRepository {
  Future<Either<Failure, List<RoleEntity>>> getAllRoles();
  Future<Either<Failure, List<RoleEntity>>> getRolesPersonnel();
}
