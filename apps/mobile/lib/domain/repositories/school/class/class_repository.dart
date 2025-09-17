// domain/repositories/class_repository.dart
import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_detail_view_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';

abstract class ClassRepository {
  Future<List<ClassSearchEntity>> searchClassesInSchool(
    String schoolId,
    String? query,
  );

  Future<List<ClassSearchEntity>> getClassesInSchool(String schoolId);

  Future<List<ClassDetailViewEntity>> getAllClassDetailView({
    int page = AppConstants.defaultPage,
    int limit = AppConstants.defaultLimit,
    Map<String, String>? sort,
    Map<String, dynamic>? filter,
  });

  Future<ClassEntity> createClass(ClassEntity createClassData);

  Future<ClassEntity> getClassById(String id);

  Future<ClassEntity> updateClass(ClassEntity updateClassData);

  Future<void> deleteClass(String id);
}
