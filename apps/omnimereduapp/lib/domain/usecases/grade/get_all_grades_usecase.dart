import '../../entities/grade/grade_entity.dart';
import '../../entities/query/default_query_entity.dart';
import '../../repositories/school/grade_repository.dart';

class GetAllGradesUseCase {
  final GradeRepository repository;

  GetAllGradesUseCase(this.repository);

  Future<List<GradeEntity>> call(DefaultQueryEntity query) async {
    return await repository.getAllGrades(query);
  }
}
