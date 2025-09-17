import 'package:flutter_ios_android_platforms/data/datasources/remote/school/grade_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/models/grade/grade_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/grade/grade_select_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/grade_repository.dart';

class GradeRepositoryImpl implements GradeRepository {
  final GradeRemoteDataSource remote;

  GradeRepositoryImpl(this.remote);

  @override
  Future<List<GradeEntity>> getAllGrades({
    int page = 1,
    int limit = 20,
    Map<String, String>? sort,
    Map<String, dynamic>? filter,
  }) async {
    try {
      final models = await remote.getAllGrades(
        page: page,
        limit: limit,
        sort: sort,
        filter: filter,
      );
      return models.map((m) => m.toEntity()).toList();
    } catch (e, st) {
      print("❌ Lỗi khi lấy danh sách grade: $e\n$st");
      throw Exception("Không thể lấy danh sách grade");
    }
  }

  @override
  Future<GradeEntity> getGradeById(String id) async {
    try {
      final model = await remote.getGradeById(id);
      return model.toEntity();
    } catch (e) {
      throw Exception("Không thể lấy grade: $e");
    }
  }

  @override
  Future<void> createGrade(GradeEntity grade) async {
    try {
      final model = GradeModel.fromEntity(grade);
      await remote.createGrade(model);
    } catch (e) {
      throw Exception("Không thể tạo grade: $e");
    }
  }

  @override
  Future<void> updateGrade(GradeEntity grade) async {
    try {
      final model = GradeModel.fromEntity(grade);
      await remote.updateGrade(model);
    } catch (e) {
      throw Exception("Không thể cập nhật grade: $e");
    }
  }

  @override
  Future<void> deleteGrade(String id) async {
    try {
      await remote.deleteGrade(id);
    } catch (e, st) {
      throw Exception("Xóa grade thất bại: $e\n$st");
    }
  }

  @override
  Future<List<GradeSelectEntity>> getGradesForSelect() async {
    try {
      final models = await remote.getGradesForSelect();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw Exception("Không thể lấy danh sách grade select: $e");
    }
  }
}
