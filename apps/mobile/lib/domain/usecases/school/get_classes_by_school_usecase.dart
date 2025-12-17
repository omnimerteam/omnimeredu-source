import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/either.dart';
import '../../entities/class/class_selector_entity.dart';
import '../../repositories/school/class_repository.dart';

class GetClassesBySchoolUseCase
    implements
        UseCase<
          Either<Failure, List<ClassSelectorEntity>>,
          GetClassesBySchoolParams
        > {
  final ClassRepository repository;

  GetClassesBySchoolUseCase(this.repository);

  @override
  Future<Either<Failure, List<ClassSelectorEntity>>> call(
    GetClassesBySchoolParams params,
  ) async {
    return await repository.getClassesBySchool(
      schoolId: params.schoolId,
      grade: params.grade,
    );
  }
}

class GetClassesBySchoolParams {
  final String schoolId;
  final String? grade;

  GetClassesBySchoolParams({required this.schoolId, this.grade});
}
