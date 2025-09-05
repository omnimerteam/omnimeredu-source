// domain/repositories/class_repository.dart
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';

abstract class ClassRepository {
  Future<List<ClassSearchEntity>> searchClassesInSchool(
    String schoolId,
    String? query,
  );

  Future<List<ClassSearchEntity>> getClassesInSchool(String schoolId);
}
