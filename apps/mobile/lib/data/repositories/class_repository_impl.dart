// data/repositories/class_repository_impl.dart

import 'package:flutter_ios_android_platforms/data/datasources/remote/class/class_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassRemoteDataSource remote;

  ClassRepositoryImpl(this.remote);

  @override
  Future<List<ClassSearchEntity>> searchClassesInSchool(
    String schoolId,
    String? query,
  ) {
    return remote.searchClassesInSchool(schoolId, query);
  }

  @override
  Future<List<ClassSearchEntity>> getClassesInSchool(String schoolId) {
    return remote.searchClassesInSchool(schoolId, null);
  }
}
