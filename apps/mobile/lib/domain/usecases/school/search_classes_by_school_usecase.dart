import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/core/utils/either.dart';
import 'package:mobile/domain/entities/class/class_selector_entity.dart';
import 'package:mobile/domain/repositories/school/class_repository.dart';

class SearchClassesBySchoolUseCase
    implements UseCase<Either<Failure, List<ClassSelectorEntity>>, String> {
  final ClassRepository repository;

  SearchClassesBySchoolUseCase(this.repository);

  @override
  Future<Either<Failure, List<ClassSelectorEntity>>> call(
    String schoolId,
  ) async {
    return await repository.searchClassesBySchool(schoolId);
  }
}
