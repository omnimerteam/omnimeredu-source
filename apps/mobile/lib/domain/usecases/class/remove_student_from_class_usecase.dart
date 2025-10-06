import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';

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
