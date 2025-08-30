import '../entities/role.dart';
import '../repositories/role_repository.dart';

class GetAllRolesUseCase {
  final RoleRepository repository;

  GetAllRolesUseCase(this.repository);

  Future<List<RoleEntity>> call() async {
    final result = await repository.getAllRoles();
    print("UseCase roles: $result");
    return result;
  }
}
