import '../../../core/usecases/usecase.dart';
import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../repositories/school/class_repository.dart';

class DeleteClassUseCase implements UseCase<Either<Failure, void>, String> {
  final ClassRepository repository;

  DeleteClassUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.deleteClass(params);
  }
}
