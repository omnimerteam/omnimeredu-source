import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../repositories/school_repository.dart';
import '../../entities/school/class_entity.dart';

class GetClassesBySchoolUseCase {
  final SchoolRepository repository;

  GetClassesBySchoolUseCase(this.repository);

  Future<Either<Failure, List<ClassEntity>>> call({
    required String schoolId,
    String? grade,
  }) async {
    return await repository.getClassesBySchool(
      schoolId: schoolId,
      grade: grade,
    );
  }
}
