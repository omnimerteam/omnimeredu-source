import '../../entities/user/student_entity.dart';
import '../../repositories/user/student_repository.dart';

class CreateStudentUseCase {
  final StudentRepository repository;

  CreateStudentUseCase(this.repository);

  Future<StudentEntity> call(StudentEntity createStudentData) async {
    return await repository.createStudent(createStudentData);
  }
}
