import 'package:mobile/core/constants/enum_constant.dart';
import 'package:mobile/domain/repositories/school/school_repository.dart';

import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/school/school_selector_entity.dart';

class GetSchoolsByLevelUseCase {
  final SchoolRepository repository;

  GetSchoolsByLevelUseCase(this.repository);

  Future<Either<Failure, List<SchoolSelectorEntity>>> call({
    required EducationSystemLevelsEnum educationLevel,
    String? search,
  }) async {
    return await repository.getSchoolsByLevel(
      educationLevel: educationLevel,
      search: search,
    );
  }
}
