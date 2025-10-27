import '../../entities/class/class_entity.dart';
import '../../entities/query/default_query_entity.dart';
import '../../repositories/school/class/class_repository.dart';

class GetAllClassUseCase {
  final ClassRepository repository;

  GetAllClassUseCase(this.repository);

  Future<List<ClassEntity>> call(DefaultQueryEntity query) async {
    return await repository.getAllClasses(query);
  }
}
