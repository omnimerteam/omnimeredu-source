import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/class/class_entity.dart';
import '../../repositories/class_repository.dart';

class UpdateClassUseCase {
  final ClassRepository repository;

  UpdateClassUseCase(this.repository);

  Future<Either<Failure, ClassEntity>> call(ClassEntity classEntity) async {
    return await repository.updateClass(classEntity);
  }
}
