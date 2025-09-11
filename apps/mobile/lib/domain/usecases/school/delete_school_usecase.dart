import 'package:flutter_ios_android_platforms/domain/repositories/school/school_repository.dart';

class DeleteSchoolUseCase {
  final SchoolRepository repository;

  DeleteSchoolUseCase(this.repository);

  Future<void> call() async {
    return await repository.deleteSchool();
  }
}
