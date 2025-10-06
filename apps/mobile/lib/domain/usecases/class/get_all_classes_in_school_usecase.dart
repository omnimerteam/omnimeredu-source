import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';

class GetAllClassesInSchoolUseCase {
  final ClassRepository repository;
  GetAllClassesInSchoolUseCase(this.repository);

  Future<List<ClassSearchEntity>> call(String schoolId) async {
    return await repository.getClassesInSchool(schoolId);
  }
}
