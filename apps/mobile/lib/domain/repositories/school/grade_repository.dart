import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_select_entity.dart';

abstract class GradeRepository {
  Future<List<GradeEntity>> getAllGrades({
    int page,
    int limit,
    Map<String, String>? sort,
    Map<String, dynamic>? filter,
  });

  Future<GradeEntity> getGradeById(String id);

  Future<void> createGrade(GradeEntity grade);

  Future<void> updateGrade(GradeEntity grade);

  Future<void> deleteGrade(String id);

  Future<List<GradeSelectEntity>> getGradesForSelect();
}
