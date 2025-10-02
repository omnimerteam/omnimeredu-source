import 'package:flutter_ios_android_platforms/core/error/failures.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/class/class_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/models/class/class_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/view_model/class_detail_view_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassRemoteDataSource remote;

  ClassRepositoryImpl(this.remote);
  @override
  Future<List<ClassSearchEntity>> getClassesInSchool(String schoolId) async {
    return await remote.searchClassesInSchool(schoolId);
  }

  @override
  Future<List<ClassEntity>> getAllClasses(DefaultQueryEntity query) async {
    try {
      final models = await remote.getAllClasses(query);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw ServerFailure("Không thể lấy danh sách lớp");
    }
  }

  @override
  Future<ClassEntity> getClassById(String id) async {
    try {
      final model = await remote.getClassById(id);

      return model.toEntity();
    } catch (e) {
      throw ServerFailure("Không thể lấy danh sách lớp: $e");
    }
  }

  @override
  Future<ClassEntity> createClass(ClassEntity createClassData) async {
    try {
      final model = ClassModel.fromEntity(createClassData);
      final creatModel = await remote.createClass(model);
      return creatModel.toEntity();
    } catch (e) {
      // có thể log stacktrace để debug
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ClassEntity> updateClass(ClassEntity updateClassData) async {
    try {
      final model = ClassModel.fromEntity(updateClassData);
      final updatedModel = await remote.updateClass(model);
      return updatedModel.toEntity();
    } catch (e) {
      // có thể log stacktrace để debug
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteClass(String id) async {
    try {
      await remote.deleteClass(id);
    } catch (e, st) {
      // Có thể log stacktrace để debug
      throw ServerFailure("Xóa trường thất bại: $e\n$st");
    }
  }

  @override
  Future<ClassDetailViewEntity> getClassDetailViewById(String id) async {
    try {
      final model = await remote.getClassDetailViewById(id);

      return model.toEntity();
    } catch (e) {
      throw ServerFailure("Không thể lấy danh sách lớp: $e");
    }
  }
}
