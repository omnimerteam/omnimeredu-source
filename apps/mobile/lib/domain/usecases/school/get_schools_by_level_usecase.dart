// domain/usecases/school/get_schools_by_level_usecase.dart
import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/school/school_search_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/school_repository.dart';

class GetSchoolsByLevelUseCase {
  final SchoolRepository repository;

  GetSchoolsByLevelUseCase(this.repository);

  Future<List<SchoolSearchEntity>> call(
    EducationSystemLevelsEnum educationLevel,
  ) async {
    return await repository.getSchoolsByLevel(educationLevel);
  }
}
