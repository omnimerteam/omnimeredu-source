import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../entities/school/class_selector_entity.dart';

abstract class ClassRepository {
  Future<Either<Failure, List<ClassSelectorEntity>>> getClassesBySchool({
    required String schoolId,
    String? grade,
  });
}
