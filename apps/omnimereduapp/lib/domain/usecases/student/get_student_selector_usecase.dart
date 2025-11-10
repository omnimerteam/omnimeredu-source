import '../../../core/network/api_response.dart';
import '../../entities/user/student_selector_entity.dart';
import '../../repositories/user/student_repository.dart';

class GetStudentSelectorUseCase {
  StudentRepository repo;

  GetStudentSelectorUseCase(this.repo);

  Future<ApiResponse<List<StudentSelectorEntity>?>> call(
    String? gradeId,
  ) async {
    return await repo.getStudentSelector(gradeId);
  }
}
