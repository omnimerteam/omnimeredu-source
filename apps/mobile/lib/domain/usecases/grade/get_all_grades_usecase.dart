import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/either.dart';
import '../../entities/grade/grade_entity.dart';
import '../../entities/query/default_query_entity.dart';
import '../../repositories/school/grade_repository.dart';

class GetAllGradesUseCase
    implements UseCase<Either<Failure, List<GradeEntity>>, DefaultQueryEntity> {
  final GradeRepository repository;

  GetAllGradesUseCase(this.repository);

  @override
  Future<Either<Failure, List<GradeEntity>>> call(
    DefaultQueryEntity params,
  ) async {
    return await repository.getAllGrades(params);
  }
}
