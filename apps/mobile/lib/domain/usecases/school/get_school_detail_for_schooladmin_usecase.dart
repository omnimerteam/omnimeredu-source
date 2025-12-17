import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/core/utils/either.dart';
import 'package:mobile/domain/entities/school/school_data_entity.dart';
import 'package:mobile/domain/repositories/school/school_repository.dart';

class GetSchoolDetailForSchoolAdminUseCase
    implements UseCase<Either<Failure, SchoolDataEntity?>, NoParams> {
  final SchoolRepository repository;

  GetSchoolDetailForSchoolAdminUseCase(this.repository);

  @override
  Future<Either<Failure, SchoolDataEntity?>> call(NoParams params) async {
    return await repository.getSchoolDetailForSchoolAdmin();
  }
}
