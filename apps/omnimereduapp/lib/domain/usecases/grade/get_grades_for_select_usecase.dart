import '../../entities/grade/grade_select_entity.dart';
import '../../repositories/school/grade_repository.dart';

class GetGradesForSelectUseCase {
  final GradeRepository repository;

  GetGradesForSelectUseCase(this.repository);

  Future<List<GradeSelectEntity>> call() async {
    return await repository.getGradesForSelect();
  }
}
