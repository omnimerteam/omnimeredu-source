import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/grade_repository.dart';

class GetAllGradesUseCase {
  final GradeRepository repository;

  GetAllGradesUseCase(this.repository);

  Future<List<GradeEntity>> call(DefaultQueryEntity query) async {
    return await repository.getAllGrades(query);
  }
}
