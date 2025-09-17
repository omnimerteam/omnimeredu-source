import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_select_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/grade_repository.dart';

class GetGradesForSelectUseCase {
  final GradeRepository repository;

  GetGradesForSelectUseCase(this.repository);

  Future<List<GradeSelectEntity>> call() async {
    return await repository.getGradesForSelect();
  }
}
