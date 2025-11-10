import '../../../core/network/api_response.dart';
import '../../entities/teaching_assignment/teaching_assignment_entity.dart';
import '../../repositories/school/class/teaching_assignment_repository.dart';

class CreateTeachingAssignmentUseCase {
  final TeachingAssignmentRepository repository;

  CreateTeachingAssignmentUseCase(this.repository);

  Future<ApiResponse<TeachingAssignmentEntity?>> call(
    TeachingAssignmentEntity data,
  ) async {
    return await repository.createTeachingAssignment(data);
  }
}
