import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/grade_repository.dart';

class GetAllGradesUseCase {
  final GradeRepository repository;

  GetAllGradesUseCase(this.repository);

  Future<List<GradeEntity>> call({
    int page = 1,
    int limit = 20,
    Map<String, String>? sort,
    Map<String, dynamic>? filter,
  }) async {
    return await repository.getAllGrades(
      page: page,
      limit: limit,
      sort: sort,
      filter: filter,
    );
  }
}
