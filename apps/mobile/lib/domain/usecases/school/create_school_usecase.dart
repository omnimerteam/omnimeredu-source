import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/either.dart';
import '../../entities/school/school_data_entity.dart';
import '../../repositories/school/school_repository.dart';

class CreateSchoolUseCase
    implements UseCase<Either<Failure, SchoolDataEntity>, SchoolDataEntity> {
  final SchoolRepository repository;

  CreateSchoolUseCase(this.repository);

  @override
  Future<Either<Failure, SchoolDataEntity>> call(
    SchoolDataEntity createSchoolData,
  ) async {
    return await repository.createSchool(createSchoolData);
  }
}
