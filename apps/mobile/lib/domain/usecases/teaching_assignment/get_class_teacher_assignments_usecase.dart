import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/teaching_assignment/class_teacher_assign_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/teaching_assignment_repository.dart';

class GetClassTeacherAssignmentsUseCase {
  final TeachingAssignmentRepository repository;

  GetClassTeacherAssignmentsUseCase(this.repository);

  Future<ApiResponse<List<ClassTeacherAssignEntity>?>> call(
    String teacherId,
    String schoolId,
  ) {
    return repository.getClassTeacherAssignments(teacherId, schoolId);
  }
}
