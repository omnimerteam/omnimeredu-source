import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/view_model/attendance_record_view_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/attendance/attendance_repository.dart';

class GetClassAttendanceRecordViewUseCase {
  final AttendanceRepository repository;

  GetClassAttendanceRecordViewUseCase(this.repository);

  Future<ApiResponse<AttendanceRecordViewEntity?>> call(
    DateTime date,
    String classId,
  ) async {
    return await repository.getClassAttendanceRecordView(date, classId);
  }
}
