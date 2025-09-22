// domain/repositories/school_repository.dart
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/school/school_data_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/school/school_search_entity.dart';

abstract class SchoolRepository {
  Future<SchoolDataEntity?> getSchoolDetailForSchoolAdmin();
  Future<SchoolDataEntity> createSchool(SchoolDataEntity createSchoolData);
  Future<SchoolDataEntity> updateSchool(SchoolDataEntity updateSchoolData);
  Future<void> deleteSchool();
  Future<List<SchoolSearchEntity>> getSchoolsByLevel(
    EducationSystemLevelsEnum educationLevel,
  );
  Future<List<SchoolSearchEntity>> searchSchoolsByLevel(
    EducationSystemLevelsEnum educationLevel,
    String? query,
  );
}
