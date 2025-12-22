import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/either.dart';
import '../../entities/grade/grade_entity.dart';
import '../../repositories/school/grade_repository.dart';

class CreateGradeUseCase
    implements UseCase<Either<Failure, GradeEntity>, GradeEntity> {
  final GradeRepository repository;

  CreateGradeUseCase(this.repository);

  @override
  Future<Either<Failure, GradeEntity>> call(GradeEntity params) async {
    return await repository.createGrade(params);
  }
}
