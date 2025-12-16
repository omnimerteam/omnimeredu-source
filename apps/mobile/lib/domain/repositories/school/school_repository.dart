// domain/repositories/school_repository.dart
import 'package:mobile/domain/entities/school/school_data_entity.dart';
import 'package:mobile/domain/entities/school/school_selector_entity.dart';

import '../../../../core/constants/enum_constant.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';

abstract class SchoolRepository {
  // Existing - Registration etc.
  Future<Either<Failure, List<SchoolSelectorEntity>>> getSchoolsByLevel({
    required EducationSystemLevelsEnum educationLevel,
    String? search,
  });
  // New - School Admin management
  Future<SchoolDataEntity?> getSchoolDetailForSchoolAdmin();
  Future<SchoolDataEntity> createSchool(SchoolDataEntity createSchoolData);
  Future<SchoolDataEntity> updateSchool(SchoolDataEntity updateSchoolData);
  Future<void> deleteSchool();
}
