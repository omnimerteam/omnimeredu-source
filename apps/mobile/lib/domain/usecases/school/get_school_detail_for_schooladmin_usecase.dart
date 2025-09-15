import 'package:flutter_ios_android_platforms/domain/entities/school/school_data_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/school_repository.dart';

class GetSchoolDetailForSchoolAdminUseCase {
  final SchoolRepository repository;

  GetSchoolDetailForSchoolAdminUseCase(this.repository);

  Future<SchoolDataEntity?> call() async {
    return await repository.getSchoolDetailForSchoolAdmin();
  }
}
