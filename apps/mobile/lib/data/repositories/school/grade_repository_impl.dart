import 'package:flutter_ios_android_platforms/core/error/failures.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/grade_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/models/grade/grade_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_select_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/grade_repository.dart';

class GradeRepositoryImpl implements GradeRepository {
  final GradeRemoteDataSource remote;

  GradeRepositoryImpl(this.remote);

  @override
  Future<List<GradeEntity>> getAllGrades(DefaultQueryEntity query) async {
    try {
      final models = await remote.getAllGrades(query);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw ServerFailure("Không thể lấy danh sách grade");
    }
  }

  @override
  Future<GradeEntity> getGradeById(String id) async {
    try {
      final model = await remote.getGradeById(id);
      return model.toEntity();
    } catch (e) {
      throw ServerFailure("Không thể lấy grade: $e");
    }
  }

  @override
  Future<void> createGrade(GradeEntity grade) async {
    try {
      final model = GradeModel.fromEntity(grade);
      await remote.createGrade(model);
    } catch (e) {
      throw ServerFailure("Không thể tạo grade: $e");
    }
  }

  @override
  Future<void> updateGrade(GradeEntity grade) async {
    try {
      final model = GradeModel.fromEntity(grade);
      await remote.updateGrade(model);
    } catch (e) {
      throw ServerFailure("Không thể cập nhật grade: $e");
    }
  }

  @override
  Future<void> deleteGrade(String id) async {
    try {
      await remote.deleteGrade(id);
    } catch (e, st) {
      throw ServerFailure("Xóa grade thất bại: $e\n$st");
    }
  }

  @override
  Future<List<GradeSelectEntity>> getGradesForSelect() async {
    try {
      final models = await remote.getGradesForSelect();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw ServerFailure("Không thể lấy danh sách grade select: $e");
    }
  }
}
