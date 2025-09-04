import '../../entities/auth/role.dart';
import '../../repositories/auth/role_repository.dart';

class GetAllRolesUseCase {
  final RoleRepository repository;

  GetAllRolesUseCase(this.repository);

  Future<List<RoleEntity>> call() async {
    return await repository.getAllRoles();
  }
}
