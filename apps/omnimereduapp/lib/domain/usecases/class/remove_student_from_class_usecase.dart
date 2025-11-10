import '../../../core/network/api_response.dart';
import '../../repositories/school/class/class_repository.dart';

class RemoveStudentFromClassUseCase {
  final ClassRepository repository;

  RemoveStudentFromClassUseCase(this.repository);

  Future<ApiResponse<void>> call(
    String classId,
    List<String> studentIds,
  ) async {
    return await repository.removeStudentFromClass(classId, studentIds);
  }
}
