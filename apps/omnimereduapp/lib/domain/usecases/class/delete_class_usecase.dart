import '../../repositories/school/class/class_repository.dart';

class DeleteClassUseCase {
  final ClassRepository repository;
  DeleteClassUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteClass(id);
  }
}
