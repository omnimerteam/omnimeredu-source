import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';

abstract class ClassRepository {
  Future<List<ClassSearchEntity>> getClassesInSchool(String schoolId);

  Future<List<ClassEntity>> getAllClasses(DefaultQueryEntity query);

  Future<ClassEntity> createClass(ClassEntity createClassData);

  Future<ClassEntity> getClassById(String id);

  Future<ClassEntity> updateClass(ClassEntity updateClassData);

  Future<void> deleteClass(String id);
}
