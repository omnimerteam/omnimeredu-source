import 'package:flutter_ios_android_platforms/domain/entities/user/student_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/student_repository.dart';

class UpdateStudentUseCase {
  final StudentRepository repository;

  UpdateStudentUseCase(this.repository);

  Future<StudentEntity> call(StudentEntity updateStudentData) async {
    final res = await repository.updateStudent(updateStudentData);
    return res.data!;
  }
}
