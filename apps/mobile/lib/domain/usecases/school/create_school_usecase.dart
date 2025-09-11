import 'package:flutter_ios_android_platforms/domain/entities/school/school_data_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/school_repository.dart';

class CreateSchoolUseCase {
  final SchoolRepository repository;

  CreateSchoolUseCase(this.repository);

  Future<SchoolDataEntity> call(SchoolDataEntity createSchoolData) async {
    return await repository.createSchool(createSchoolData);
  }
}
