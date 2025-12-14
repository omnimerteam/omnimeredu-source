import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../entities/school/school_entity.dart';
import '../entities/school/class_entity.dart';

abstract class SchoolRepository {
  Future<Either<Failure, List<SchoolEntity>>> getSchoolsByLevel({
    required String educationLevel,
    String? search,
  });
  Future<Either<Failure, List<ClassEntity>>> getClassesBySchool({
    required String schoolId,
    String? grade,
  });
}
