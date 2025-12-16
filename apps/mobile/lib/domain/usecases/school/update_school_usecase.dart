import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/either.dart';
import '../../entities/school/school_data_entity.dart';
import '../../repositories/school/school_repository.dart';

class UpdateSchoolUseCase
    implements UseCase<Either<Failure, SchoolDataEntity>, SchoolDataEntity> {
  final SchoolRepository repository;

  UpdateSchoolUseCase(this.repository);

  @override
  Future<Either<Failure, SchoolDataEntity>> call(
    SchoolDataEntity updateSchoolData,
  ) async {
    return await repository.updateSchool(updateSchoolData);
  }
}
