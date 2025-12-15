import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/school/class_selector_entity.dart';
import '../../domain/repositories/class_repository.dart';
import '../datasources/remote/school/class_remote_data_source.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassRemoteDataSource remoteDataSource;

  ClassRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ClassSelectorEntity>>> getClassesBySchool({
    required String schoolId,
    String? grade,
  }) async {
    try {
      final classes = await remoteDataSource.getClassesBySchool(
        schoolId: schoolId,
        grade: grade,
      );
      return Right(classes);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
