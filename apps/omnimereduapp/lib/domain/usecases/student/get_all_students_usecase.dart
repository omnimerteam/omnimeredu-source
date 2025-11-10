import '../../entities/query/default_query_entity.dart';
import '../../entities/user/student_entity.dart';
import '../../repositories/user/student_repository.dart';

class GetAllStudentsUseCase {
  final StudentRepository repository;

  GetAllStudentsUseCase(this.repository);

  Future<List<StudentEntity>> call(DefaultQueryEntity query) async {
    return await repository.getAllStudents(query);
  }
}
