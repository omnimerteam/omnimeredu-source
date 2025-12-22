import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/class/class_entity.dart';
import '../../entities/class/class_selector_entity.dart';
import '../../entities/query/default_query_entity.dart';

abstract class ClassRepository {
  Future<Either<Failure, List<ClassSelectorEntity>>> getClassesBySchool({
    required String schoolId,
  });

  Future<Either<Failure, List<ClassEntity>>> getAllClasses(
    DefaultQueryEntity query,
  );

  Future<Either<Failure, ClassEntity>> createClass(ClassEntity createClassData);

  Future<Either<Failure, ClassEntity>> getClassById(String id);

  Future<Either<Failure, ClassEntity>> updateClass(ClassEntity updateClassData);

  Future<Either<Failure, void>> deleteClass(String id);

  Future<Either<Failure, List<ClassSelectorEntity>>> searchClassesBySchool(
    String schoolId,
  );
}
