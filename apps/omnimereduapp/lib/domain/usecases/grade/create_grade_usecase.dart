import '../../entities/grade/grade_entity.dart';
import '../../repositories/school/grade_repository.dart';

class CreateGradeUseCase {
  final GradeRepository repository;

  CreateGradeUseCase(this.repository);

  Future<void> call(GradeEntity grade) async {
    return await repository.createGrade(grade);
  }
}
