import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/typedefs.dart';
import '../../../../../../core/constants/enum_constant.dart';
import '../../../../../../domain/entities/school/school_entity.dart';
import '../../../../../../domain/repositories/school_repository.dart';
import 'package:dartz/dartz.dart';

class GetSchoolsByLevelUseCase {
  final SchoolRepository repository;

  GetSchoolsByLevelUseCase(this.repository);

  FutureResult<List<SchoolEntity>> call(EducationSystemLevelsEnum level) async {
    return await repository.getSchoolsByLevel(level);
  }
}