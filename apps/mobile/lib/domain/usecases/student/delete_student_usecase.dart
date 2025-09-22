import 'package:flutter_ios_android_platforms/domain/repositories/user/student_repository.dart';

class DeleteStudentUseCase {
  final StudentRepository repository;

  DeleteStudentUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteStudent(id);
  }
}
