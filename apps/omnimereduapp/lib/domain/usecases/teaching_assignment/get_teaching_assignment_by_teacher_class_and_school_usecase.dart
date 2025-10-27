import '../../../core/network/api_response.dart';
import '../../entities/teaching_assignment/teaching_assignment_entity.dart';
import '../../repositories/school/class/teaching_assignment_repository.dart';

class GetTeachingAssignmentByTeacherClassAndSchoolUseCase {
  final TeachingAssignmentRepository repository;

  GetTeachingAssignmentByTeacherClassAndSchoolUseCase(this.repository);

  Future<ApiResponse<TeachingAssignmentEntity?>> call(
    String teacherId,
    String schoolId,
    String classId,
  ) async {
    return await repository.getTeachingAssignmentByTeacherClassAndSchool(
      teacherId,
      schoolId,
      classId,
    );
  }
}
