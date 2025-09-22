import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/student_repository.dart';

class GetAllStudentsUseCase {
  final StudentRepository repository;

  GetAllStudentsUseCase(this.repository);

  Future<List<StudentEntity>> call(DefaultQueryEntity query) async {
    return await repository.getAllStudents(query);
  }
}
