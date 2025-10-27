import '../../repositories/school/grade_repository.dart';

class DeleteGradeUseCase {
  final GradeRepository repository;

  DeleteGradeUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteGrade(id);
  }
}
