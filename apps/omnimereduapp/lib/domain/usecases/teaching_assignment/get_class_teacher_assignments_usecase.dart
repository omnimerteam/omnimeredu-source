import '../../../core/network/api_response.dart';
import '../../entities/teaching_assignment/class_teacher_assign_entity.dart';
import '../../repositories/school/class/teaching_assignment_repository.dart';

class GetClassTeacherAssignmentsUseCase {
  final TeachingAssignmentRepository repository;

  GetClassTeacherAssignmentsUseCase(this.repository);

  Future<ApiResponse<List<ClassTeacherAssignEntity>?>> call(
    String teacherId,
    String schoolId,
  ) async {
    return await repository.getClassTeacherAssignments(teacherId, schoolId);
  }
}
