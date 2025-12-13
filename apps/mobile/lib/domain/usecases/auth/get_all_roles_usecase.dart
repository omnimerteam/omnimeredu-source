import '../../../../../core/errors/failures.dart';
import '../../../../../core/typedefs.dart';
import '../../../../../domain/entities/auth/role_entity.dart';
import '../../../../../domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllRolesUseCase {
  final AuthRepository repository;

  GetAllRolesUseCase(this.repository);

  FutureResult<List<RoleEntity>> call() async {
    return await repository.getAllRoles();
  }
}