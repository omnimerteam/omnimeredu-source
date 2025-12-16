// domain/repositories/school_repository.dart
import 'package:mobile/domain/entities/school/school_data_entity.dart';
import 'package:mobile/domain/entities/school/school_selector_entity.dart';

import '../../../../core/constants/enum_constant.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';

abstract class SchoolRepository {
  Future<Either<Failure, List<SchoolSelectorEntity>>> getSchoolsByLevel({
    required EducationSystemLevelsEnum educationLevel,
    String? search,
  });

  Future<Either<Failure, SchoolDataEntity?>> getSchoolDetailForSchoolAdmin();
  Future<Either<Failure, SchoolDataEntity>> createSchool(
    SchoolDataEntity createSchoolData,
  );
  Future<Either<Failure, SchoolDataEntity>> updateSchool(
    SchoolDataEntity updateSchoolData,
  );
  Future<Either<Failure, void>> deleteSchool();
}
