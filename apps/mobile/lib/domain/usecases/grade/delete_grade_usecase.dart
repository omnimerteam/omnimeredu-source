import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/either.dart';
import '../../repositories/grade/grade_repository.dart';

class DeleteGradeUseCase implements UseCase<Either<Failure, void>, String> {
  final GradeRepository repository;

  DeleteGradeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteGrade(params);
  }
}
