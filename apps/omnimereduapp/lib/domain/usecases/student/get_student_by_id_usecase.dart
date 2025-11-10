import '../../entities/user/student_entity.dart';
import '../../repositories/user/student_repository.dart';

class GetStudentByIdUseCase {
  final StudentRepository repository;

  GetStudentByIdUseCase(this.repository);

  Future<StudentEntity> call(String id) async {
    return await repository.getStudentById(id);
  }
}
