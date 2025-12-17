import '../../../core/usecases/usecase.dart';
import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/class/class_entity.dart';
import '../../repositories/school/class_repository.dart';

class CreateClassUseCase
    implements UseCase<Either<Failure, ClassEntity>, ClassEntity> {
  final ClassRepository repository;

  CreateClassUseCase(this.repository);

  @override
  Future<Either<Failure, ClassEntity>> call(ClassEntity params) async {
    return await repository.createClass(params);
  }
}
