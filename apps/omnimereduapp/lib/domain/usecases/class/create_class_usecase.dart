import '../../entities/class/class_entity.dart';
import '../../repositories/school/class/class_repository.dart';

class CreateClassUseCase {
  final ClassRepository repository;
  CreateClassUseCase(this.repository);

  Future<ClassEntity> call(ClassEntity createClassData) async {
    return await repository.createClass(createClassData);
  }
}
