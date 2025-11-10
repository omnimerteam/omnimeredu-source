// domain/usecases/school/get_schools_by_level_usecase.dart
import '../../entities/school/school_data_entity.dart';
import '../../repositories/school/school_repository.dart';

class UpdateSchoolUseCase {
  final SchoolRepository repository;

  UpdateSchoolUseCase(this.repository);

  Future<SchoolDataEntity> call(SchoolDataEntity updateSchoolData) async {
    return await repository.updateSchool(updateSchoolData);
  }
}
