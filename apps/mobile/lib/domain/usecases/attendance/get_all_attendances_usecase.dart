import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/attendance/attendance_class_entity.dart';
import '../../entities/query/default_query_entity.dart';
import '../../repositories/attendance/attendance_repository.dart';

class GetAllAttendancesUseCase
    extends
        UseCase<
          Either<Failure, List<AttendanceClassEntity>?>,
          DefaultQueryEntity
        > {
  final AttendanceRepository repository;

  GetAllAttendancesUseCase(this.repository);

  @override
  Future<Either<Failure, List<AttendanceClassEntity>?>> call(
    DefaultQueryEntity params,
  ) async {
    return await repository.getAllAttendances(params);
  }
}
