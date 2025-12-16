import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../repositories/class_repository.dart';

class DeleteClassUseCase {
  final ClassRepository repository;

  DeleteClassUseCase(this.repository);

  Future<Either<Failure, void>> call(String classId) async {
    return await repository.deleteClass(classId);
  }
}
