import '../../entities/class/class_entity.dart';
import '../../repositories/school/class/class_repository.dart';

class UpdateClassUseCase {
  final ClassRepository repository;
  UpdateClassUseCase(this.repository);

  Future<ClassEntity> call(ClassEntity updateClassData) async {
    return await repository.updateClass(updateClassData);
  }
}
