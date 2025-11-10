import '../../entities/auth/role_entity.dart';
import '../../repositories/auth/role_repository.dart';

class GetRolesPersonnelUseCase {
  final RoleRepository repository;

  GetRolesPersonnelUseCase(this.repository);

  Future<List<RoleEntity>> call() async {
    return await repository.getRolesPersonnel();
  }
}
