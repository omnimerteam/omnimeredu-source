import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/teaching_assignment/teaching_assignment_entity.dart';

abstract class TeachingAssignmentRepository {
  Future<ApiResponse<TeachingAssignmentEntity?>>
  getTeachingAssignmentByTeacherAndSchoolId(String teacherId, String schoolId);

  Future<ApiResponse<TeachingAssignmentEntity>> createTeachingAssignment(
    TeachingAssignmentEntity data,
  );

  Future<ApiResponse<TeachingAssignmentEntity>> updateTeachingAssignment(
    TeachingAssignmentEntity data,
  );

  Future<ApiResponse<void>> deleteTeachingAssignment(String id);
}
