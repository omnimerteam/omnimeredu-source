import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/attendance/attendance_repository.dart';

class DeleteAttendanceUseCase extends UseCase<Either<Failure, bool?>, String> {
  final AttendanceRepository repository;

  DeleteAttendanceUseCase(this.repository);

  @override
  Future<Either<Failure, bool?>> call(String params) async {
    return await repository.deleteAttendance(params);
  }
}
