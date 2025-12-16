import 'package:mobile/core/constants/enum_constant.dart';
import 'package:mobile/domain/repositories/school/school_repository.dart';

import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/school/school_selector_entity.dart';

class GetSchoolsByLevelUseCase
    implements
        UseCase<
          Either<Failure, List<SchoolSelectorEntity>>,
          GetSchoolsByLevelParams
        > {
  final SchoolRepository repository;

  GetSchoolsByLevelUseCase(this.repository);

  @override
  Future<Either<Failure, List<SchoolSelectorEntity>>> call(
    GetSchoolsByLevelParams params,
  ) async {
    return await repository.getSchoolsByLevel(
      educationLevel: params.educationLevel,
      search: params.search,
    );
  }
}

class GetSchoolsByLevelParams {
  final EducationSystemLevelsEnum educationLevel;
  final String? search;

  GetSchoolsByLevelParams({required this.educationLevel, this.search});
}
