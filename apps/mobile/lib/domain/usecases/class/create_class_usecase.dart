import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/class/class_entity.dart';
import '../../repositories/class_repository.dart';

class CreateClassUseCase {
  final ClassRepository repository;

  CreateClassUseCase(this.repository);

  Future<Either<Failure, ClassEntity>> call(ClassEntity classEntity) async {
    return await repository.createClass(classEntity);
  }
}
