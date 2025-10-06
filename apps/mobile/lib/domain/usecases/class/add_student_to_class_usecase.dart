import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/add_student_to_class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';

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
