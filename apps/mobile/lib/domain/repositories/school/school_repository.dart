// domain/repositories/school_repository.dart
import 'package:flutter_ios_android_platforms/domain/entities/school/school_search_entity.dart';

abstract class SchoolRepository {
  Future<List<SchoolSearchEntity>> getSchoolsByLevel(String educationLevel);
  Future<List<SchoolSearchEntity>> searchSchoolsByLevel(
    String educationLevel,
    String? query,
  );
}
