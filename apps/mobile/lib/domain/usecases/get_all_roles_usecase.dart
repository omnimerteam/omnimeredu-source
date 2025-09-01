import '../entities/role.dart';
import '../repositories/role_repository.dart';

class GetAllRolesUseCase {
  final RoleRepository repository;

  GetAllRolesUseCase(this.repository);

  Future<List<RoleEntity>> call() async {
    return await repository.getAllRoles();
  }
}
