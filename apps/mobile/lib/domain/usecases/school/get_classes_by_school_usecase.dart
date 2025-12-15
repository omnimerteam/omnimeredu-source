import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/school/class_selector_entity.dart';
import '../../repositories/class_repository.dart';

class GetClassesBySchoolUseCase {
  final ClassRepository repository;

  GetClassesBySchoolUseCase(this.repository);

  Future<Either<Failure, List<ClassSelectorEntity>>> call({
    required String schoolId,
    String? grade,
  }) async {
    return await repository.getClassesBySchool(
      schoolId: schoolId,
      grade: grade,
    );
  }
}
