import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../repositories/school_repository.dart';
import '../../entities/school/school_entity.dart';

class GetSchoolsByLevelUseCase {
  final SchoolRepository repository;

  GetSchoolsByLevelUseCase(this.repository);

  Future<Either<Failure, List<SchoolEntity>>> call({
    required String educationLevel,
    String? search,
  }) async {
    return await repository.getSchoolsByLevel(
      educationLevel: educationLevel,
      search: search,
    );
  }
}
