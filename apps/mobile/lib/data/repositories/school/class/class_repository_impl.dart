// data/repositories/class_repository_impl.dart

import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/class/class_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/models/class/class_model.dart';

import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassRemoteDataSource remote;

  ClassRepositoryImpl(this.remote);

  @override
  Future<List<ClassSearchEntity>> searchClassesInSchool(
    String schoolId,
    String? query,
  ) async {
    return await remote.searchClassesInSchool(schoolId, query);
  }

  @override
  Future<List<ClassSearchEntity>> getClassesInSchool(String schoolId) async {
    return await remote.searchClassesInSchool(schoolId, null);
  }

  @override
  Future<List<ClassEntity>> getAllClasses(DefaultQueryEntity query) async {
    try {
      final models = await remote.getAllClasses(query);
      return models.map((m) => m.toEntity()).toList();
    } catch (e, st) {
      print("Lỗi khi lấy danh sách lớp: $e\n$st");
      throw Exception("Không thể lấy danh sách lớp");
    }
  }

  @override
  Future<ClassEntity> getClassById(String id) async {
    try {
      final model = await remote.getClassById(id);

      return model.toEntity();
    } catch (e) {
      throw Exception("Không thể lấy danh sách lớp: $e");
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
      throw Exception(e);
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
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteClass(String id) async {
    try {
      await remote.deleteClass(id);
    } catch (e, st) {
      // Có thể log stacktrace để debug
      throw Exception("Xóa trường thất bại: $e\n$st");
    }
  }
}
