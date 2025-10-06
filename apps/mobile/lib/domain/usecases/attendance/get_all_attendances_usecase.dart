import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/attendance/attendance_class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/attendance/attendance_repository.dart';

class GetAllAttendancesUseCase {
  final AttendanceRepository repository;

  GetAllAttendancesUseCase(this.repository);

  Future<ApiResponse<List<AttendanceClassEntity>?>> call(
    DefaultQueryEntity query,
  ) async {
    return await repository.getAllAttendances(query);
  }
}
