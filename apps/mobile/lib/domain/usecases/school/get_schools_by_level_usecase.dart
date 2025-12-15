import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/school/school_selector_entity.dart';
import '../../repositories/school_repository.dart';

class GetSchoolsByLevelUseCase {
  final SchoolRepository repository;

  GetSchoolsByLevelUseCase(this.repository);

  Future<Either<Failure, List<SchoolSelectorEntity>>> call({
    required String educationLevel,
    String? search,
  }) async {
    return await repository.getSchoolsByLevel(
      educationLevel: educationLevel,
      search: search,
    );
  }
}
