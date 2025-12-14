import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/school/school_entity.dart';
import '../../domain/entities/school/class_entity.dart';
import '../../domain/repositories/school_repository.dart';
import '../datasources/remote/school/school_remote_data_source.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final SchoolRemoteDataSource remoteDataSource;

  SchoolRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SchoolEntity>>> getSchoolsByLevel({
    required String educationLevel,
    String? search,
  }) async {
    try {
      final schools = await remoteDataSource.getSchoolsByLevel(
        educationLevel: educationLevel,
        search: search,
      );
      return Right(schools);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ClassEntity>>> getClassesBySchool({
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