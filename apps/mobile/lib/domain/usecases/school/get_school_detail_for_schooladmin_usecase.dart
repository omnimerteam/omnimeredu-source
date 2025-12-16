import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/either.dart';
import '../../entities/school/school_data_entity.dart';
import '../../repositories/school/school_repository.dart';

class GetSchoolDetailForSchoolAdminUseCase
    implements UseCase<Either<Failure, SchoolDataEntity?>, NoParams> {
  final SchoolRepository repository;

  GetSchoolDetailForSchoolAdminUseCase(this.repository);

  @override
  Future<Either<Failure, SchoolDataEntity?>> call(NoParams params) async {
    return await repository.getSchoolDetailForSchoolAdmin();
  }
}
