import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/detail_record/detail_record_student_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/attendance/detail_record_repository.dart';

class GetAttendanceRecordByIdUseCase {
  final DetailRecordRepository repository;

  GetAttendanceRecordByIdUseCase(this.repository);

  Future<ApiResponse<List<DetailRecordStudentEntity>?>>
  getAttendanceRecordsById(String attendanceId) async {
    return await repository.getAttendanceRecordsById(attendanceId);
  }
}
