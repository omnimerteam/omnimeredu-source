import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/attendance/attendance_entity.dart';
import '../../entities/attendance/attendance_record_view_entity.dart';
import '../../repositories/attendance/attendance_repository.dart';

class InitializeClassAttendanceUseCase
    extends
        UseCase<
          Either<Failure, AttendanceRecordViewEntity?>,
          AttendanceEntity
        > {
  final AttendanceRepository repository;

  InitializeClassAttendanceUseCase(this.repository);

  @override
  Future<Either<Failure, AttendanceRecordViewEntity?>> call(
    AttendanceEntity params,
  ) async {
    return await repository.initializeClassAttendance(params);
  }
}
