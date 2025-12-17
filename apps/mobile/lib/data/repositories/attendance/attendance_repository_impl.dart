import 'package:mobile/data/datasources/remote/attendance/attendance_remote_data_source.dart';
import 'package:mobile/data/models/attendance/attendance_model.dart';
import 'package:mobile/domain/entities/attendance/attendance_record_view_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/api_utils.dart';
import '../../../../domain/entities/attendance/attendance_class_entity.dart';
import '../../../../domain/entities/attendance/attendance_entity.dart';
import '../../../../domain/entities/query/default_query_entity.dart';
import '../../../domain/repositories/attendance/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remote;

  AttendanceRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, AttendanceEntity?>> initializeClassAttendance(
    AttendanceEntity attendanceDate,
  ) async {
    return safeApiCall(() async {
      final model = await remote.initializeClassAttendance(
        AttendanceModel.fromEntity(attendanceDate),
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, AttendanceRecordViewEntity?>>
  getClassAttendanceRecordView(DateTime date, String classId) async {
    return safeApiCall(() async {
      final model = await remote.getClassAttendanceRecordView(date, classId);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, List<AttendanceClassEntity>?>> getAllAttendances(
    DefaultQueryEntity query,
  ) async {
    return safeApiCall(() async {
      final models = await remote.getAllAttendances(query);
      return models.map((e) => e.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, bool?>> deleteAttendance(String id) async {
    return safeApiCall(() async {
      return await remote.deleteAttendance(id);
    });
  }
}
