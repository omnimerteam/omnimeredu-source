import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/core/utils/either.dart';
import 'package:mobile/domain/repositories/school/school_repository.dart';

class DeleteSchoolUseCase implements UseCase<Either<Failure, void>, NoParams> {
  final SchoolRepository repository;

  DeleteSchoolUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.deleteSchool();
  }
}
