// domain/repositories/school_repository.dart
import '../../../../core/constants/enum_constant.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/school/school_data_entity.dart';
import '../entities/school/school_search_entity.dart';
import '../entities/school/school_selector_entity.dart';

abstract class SchoolRepository {
  // Existing - Registration etc.
  Future<Either<Failure, List<SchoolSelectorEntity>>> getSchoolsByLevel({
    required String educationLevel,
    String? search,
  });

  // New - School Admin management
  Future<SchoolDataEntity?> getSchoolDetailForSchoolAdmin();
  Future<SchoolDataEntity> createSchool(SchoolDataEntity createSchoolData);
  Future<SchoolDataEntity> updateSchool(SchoolDataEntity updateSchoolData);
  Future<void> deleteSchool();
  
  Future<List<SchoolSearchEntity>> searchSchoolsByLevel(
    EducationSystemLevelsEnum educationLevel,
    String? query,
  );
}
