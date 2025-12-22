import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/utils/either.dart';
import 'package:mobile/domain/entities/auth/role_entity.dart';

abstract class RoleRepository {
  Future<Either<Failure, List<RoleEntity>>> getAllRoles();
  Future<Either<Failure, List<RoleEntity>>> getRolesPersonnel();
}
