import '../../entities/school/school_data_entity.dart';
import '../../repositories/school/school_repository.dart';

class CreateSchoolUseCase {
  final SchoolRepository repository;

  CreateSchoolUseCase(this.repository);

  Future<SchoolDataEntity> call(SchoolDataEntity createSchoolData) async {
    return await repository.createSchool(createSchoolData);
  }
}
