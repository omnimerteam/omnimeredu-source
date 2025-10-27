import '../../entities/grade/grade_entity.dart';
import '../../repositories/school/grade_repository.dart';

class UpdateGradeUseCase {
  final GradeRepository repository;

  UpdateGradeUseCase(this.repository);

  Future<void> call(GradeEntity grade) async {
    return await repository.updateGrade(grade);
  }
}
