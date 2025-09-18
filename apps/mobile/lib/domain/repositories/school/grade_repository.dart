import 'package:flutter_ios_android_platforms/core/utils/query_builder.dart';
import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_select_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';

abstract class GradeRepository {
  Future<List<GradeEntity>> getAllGrades(DefaultQueryEntity query);

  Future<GradeEntity> getGradeById(String id);

  Future<void> createGrade(GradeEntity grade);

  Future<void> updateGrade(GradeEntity grade);

  Future<void> deleteGrade(String id);

  Future<List<GradeSelectEntity>> getGradesForSelect();
}
