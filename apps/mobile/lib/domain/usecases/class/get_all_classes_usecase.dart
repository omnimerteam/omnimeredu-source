import '../../../core/usecases/usecase.dart';
import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/query/default_query_entity.dart';
import '../../entities/class/class_entity.dart';
import '../../repositories/school/class_repository.dart';

class GetAllClassesUseCase
    implements UseCase<Either<Failure, List<ClassEntity>>, DefaultQueryEntity> {
  final ClassRepository repository;

  GetAllClassesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ClassEntity>>> call(
    DefaultQueryEntity params,
  ) async {
    return await repository.getAllClasses(params);
  }
}
