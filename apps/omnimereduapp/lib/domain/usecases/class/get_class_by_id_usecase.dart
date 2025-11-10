import '../../entities/class/class_entity.dart';
import '../../repositories/school/class/class_repository.dart';

class GetClassByIdUseCase {
  final ClassRepository repository;
  GetClassByIdUseCase(this.repository);

  Future<ClassEntity> call(String id) async {
    return await repository.getClassById(id);
  }
}
