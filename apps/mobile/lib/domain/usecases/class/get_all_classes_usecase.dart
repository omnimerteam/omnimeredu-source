import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/query/default_query_entity.dart';
import '../../entities/class/class_entity.dart';
import '../../repositories/class_repository.dart';

class GetAllClassesUseCase {
  final ClassRepository repository;

  GetAllClassesUseCase(this.repository);

  Future<Either<Failure, List<ClassEntity>>> call(
    DefaultQueryEntity query,
  ) async {
    return await repository.getAllClasses(query);
  }
}
