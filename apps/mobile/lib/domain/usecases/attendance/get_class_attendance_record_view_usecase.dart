import 'package:equatable/equatable.dart';
import 'package:mobile/domain/entities/attendance/attendance_record_view_entity.dart';

import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/attendance/attendance_repository.dart';

class GetClassAttendanceRecordViewUseCase
    extends
        UseCase<
          Either<Failure, AttendanceRecordViewEntity?>,
          GetClassAttendanceRecordViewParams
        > {
  final AttendanceRepository repository;

  GetClassAttendanceRecordViewUseCase(this.repository);

  @override
  Future<Either<Failure, AttendanceRecordViewEntity?>> call(
    GetClassAttendanceRecordViewParams params,
  ) async {
    return await repository.getClassAttendanceRecordView(
      params.date,
      params.classId,
    );
  }
}

class GetClassAttendanceRecordViewParams extends Equatable {
  final DateTime date;
  final String classId;

  const GetClassAttendanceRecordViewParams({
    required this.date,
    required this.classId,
  });

  @override
  List<Object?> get props => [date, classId];
}
