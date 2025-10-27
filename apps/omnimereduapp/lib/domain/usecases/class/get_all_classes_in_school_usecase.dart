import '../../entities/class/class_search_entity.dart';
import '../../repositories/school/class/class_repository.dart';

class GetAllClassesInSchoolUseCase {
  final ClassRepository repository;
  GetAllClassesInSchoolUseCase(this.repository);

  Future<List<ClassSearchEntity>> call(String schoolId) async {
    return await repository.getClassesInSchool(schoolId);
  }
}
