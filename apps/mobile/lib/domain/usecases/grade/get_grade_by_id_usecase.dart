import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/grade_repository.dart';

class GetGradeByIdUseCase {
  final GradeRepository repository;

  GetGradeByIdUseCase(this.repository);

  Future<GradeEntity> call(String id) async {
    return await repository.getGradeById(id);
  }
}
