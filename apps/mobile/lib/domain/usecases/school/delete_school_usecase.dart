import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/either.dart';
import '../../repositories/school/school_repository.dart';

class DeleteSchoolUseCase implements UseCase<Either<Failure, void>, NoParams> {
  final SchoolRepository repository;

  DeleteSchoolUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.deleteSchool();
  }
}
