import 'package:flutter_ios_android_platforms/domain/entities/user/student_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/student_repository.dart';

class GetStudentByIdUseCase {
  final StudentRepository repository;

  GetStudentByIdUseCase(this.repository);

  Future<StudentEntity> call(String id) async {
    return await repository.getStudentById(id);
  }
}
