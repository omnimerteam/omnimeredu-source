import '../../entities/school/school_data_entity.dart';
import '../../repositories/school/school_repository.dart';

class GetSchoolDetailForSchoolAdminUseCase {
  final SchoolRepository repository;

  GetSchoolDetailForSchoolAdminUseCase(this.repository);

  Future<SchoolDataEntity?> call() async {
    return await repository.getSchoolDetailForSchoolAdmin();
  }
}
