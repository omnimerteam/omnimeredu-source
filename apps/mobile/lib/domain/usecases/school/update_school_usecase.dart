// domain/usecases/school/get_schools_by_level_usecase.dart
import 'package:flutter_ios_android_platforms/domain/entities/school/school_data_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/school_repository.dart';

class UpdateSchoolUseCase {
  final SchoolRepository repository;

  UpdateSchoolUseCase(this.repository);

  Future<SchoolDataEntity> call(SchoolDataEntity updateSchoolData) async {
    return await repository.updateSchool(updateSchoolData);
  }
}
