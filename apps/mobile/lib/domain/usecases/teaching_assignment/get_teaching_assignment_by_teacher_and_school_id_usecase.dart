import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/teaching_assignment/teaching_assignment_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/teaching_assignment_repository.dart';

class GetTeachingAssignmentByTeacherAndSchoolIdUseCase {
  final TeachingAssignmentRepository repository;

  GetTeachingAssignmentByTeacherAndSchoolIdUseCase(this.repository);

  Future<ApiResponse<TeachingAssignmentEntity?>> call(
    String teacherId,
    String schoolId,
  ) {
    return repository.getTeachingAssignmentByTeacherAndSchoolId(
      teacherId,
      schoolId,
    );
  }
}
