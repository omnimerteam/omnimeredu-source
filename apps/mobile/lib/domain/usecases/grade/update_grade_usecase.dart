import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/either.dart';
import '../../entities/grade/grade_entity.dart';
import '../../repositories/grade/grade_repository.dart';

class UpdateGradeUseCase
    implements UseCase<Either<Failure, GradeEntity>, GradeEntity> {
  final GradeRepository repository;

  UpdateGradeUseCase(this.repository);

  @override
  Future<Either<Failure, GradeEntity>> call(GradeEntity params) async {
    return await repository.updateGrade(params);
  }
}
