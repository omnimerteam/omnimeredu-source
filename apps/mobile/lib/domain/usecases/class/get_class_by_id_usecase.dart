import '../../../core/usecases/usecase.dart';
import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/class/class_entity.dart';
import '../../repositories/school/class_repository.dart';

class GetClassByIdUseCase
    implements UseCase<Either<Failure, ClassEntity>, String> {
  final ClassRepository repository;

  GetClassByIdUseCase(this.repository);

  @override
  Future<Either<Failure, ClassEntity>> call(String params) async {
    return await repository.getClassById(params);
  }
}
