import '../../../core/network/api_response.dart';
import '../../entities/class/add_student_to_class_entity.dart';
import '../../repositories/school/class/class_repository.dart';

class AddStudentToClassUseCase {
  final ClassRepository repository;

  AddStudentToClassUseCase(this.repository);

  Future<ApiResponse<AddStudentToClassEntity?>> call(
    String classId,
    List<String> studentIds,
  ) async {
    return await repository.addStudentToClass(classId, studentIds);
  }
}
