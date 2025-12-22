import 'package:mobile/domain/entities/attendance/attendance_record_view_entity.dart';

import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../entities/attendance/attendance_class_entity.dart';
import '../../entities/attendance/attendance_entity.dart';
import '../../entities/query/default_query_entity.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, AttendanceRecordViewEntity?>>
  initializeClassAttendance(AttendanceEntity attendanceDate);

  Future<Either<Failure, AttendanceRecordViewEntity?>>
  getClassAttendanceRecordView(DateTime date, String classId);

  Future<Either<Failure, List<AttendanceClassEntity>?>> getAllAttendances(
    DefaultQueryEntity query,
  );

  Future<Either<Failure, bool?>> deleteAttendance(String id);
}
