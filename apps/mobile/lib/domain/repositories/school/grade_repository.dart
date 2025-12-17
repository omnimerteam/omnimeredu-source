import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/grade/grade_entity.dart';
import '../../entities/query/default_query_entity.dart';

abstract class GradeRepository {
  Future<Either<Failure, List<GradeEntity>>> getAllGrades(
    DefaultQueryEntity query,
  );
  Future<Either<Failure, GradeEntity>> createGrade(GradeEntity grade);
  Future<Either<Failure, GradeEntity>> updateGrade(GradeEntity grade);
  Future<Either<Failure, void>> deleteGrade(String id);
  Future<Either<Failure, GradeEntity>> getGradeById(String id);
}
