import '../../entities/grade/grade_entity.dart';
import '../../repositories/school/grade_repository.dart';

class GetGradeByIdUseCase {
  final GradeRepository repository;

  GetGradeByIdUseCase(this.repository);

  Future<GradeEntity> call(String id) async {
    return await repository.getGradeById(id);
  }
}
