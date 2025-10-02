import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/grade_repository.dart';

class CreateGradeUseCase {
  final GradeRepository repository;

  CreateGradeUseCase(this.repository);

  Future<void> call(GradeEntity grade) async {
    return await repository.createGrade(grade);
  }
}
