import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/utils/either.dart';
import 'package:mobile/domain/entities/school/school_selector_entity.dart';

abstract class SchoolRepository {
  Future<Either<Failure, List<SchoolSelectorEntity>>> getSchoolsByLevel({
    required String educationLevel,
    String? search,
  });
}
