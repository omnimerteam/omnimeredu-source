import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/school/school_selector_entity.dart';
import '../../domain/repositories/school_repository.dart';
import '../datasources/remote/school/school_remote_data_source.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final SchoolRemoteDataSource schoolRemoteDataSource;

  SchoolRepositoryImpl({required this.schoolRemoteDataSource});

  @override
  Future<Either<Failure, List<SchoolSelectorEntity>>> getSchoolsByLevel({
    required String educationLevel,
    String? search,
  }) async {
    try {
      final schools = await schoolRemoteDataSource.getSchoolsByLevel(
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
}
