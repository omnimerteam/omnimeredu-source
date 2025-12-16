import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/class/class_entity.dart';
import '../../repositories/class_repository.dart';

class GetClassByIdUseCase {
  final ClassRepository repository;

  GetClassByIdUseCase(this.repository);

  Future<Either<Failure, ClassEntity>> call(String id) async {
    return await repository.getClassById(id);
  }
}
