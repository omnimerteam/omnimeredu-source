import '../../../core/network/api_response.dart';
import '../../repositories/school/class/teaching_assignment_repository.dart';

class DeleteTeachingAssignmentUseCase {
  final TeachingAssignmentRepository repository;

  DeleteTeachingAssignmentUseCase(this.repository);

  Future<ApiResponse<void>> call(String id) async {
    return await repository.deleteTeachingAssignment(id);
  }
}
