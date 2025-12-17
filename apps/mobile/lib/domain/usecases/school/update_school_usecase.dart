import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/core/utils/either.dart';
import 'package:mobile/domain/entities/school/school_data_entity.dart';
import 'package:mobile/domain/repositories/school/school_repository.dart';

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
