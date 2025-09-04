// data/repositories/school_repository_impl.dart
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/school_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/domain/entities/school/school_search_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/school_repository.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final SchoolRemoteDataSource remote;

  SchoolRepositoryImpl(this.remote);

  @override
  Future<List<SchoolSearchEntity>> getSchoolsByLevel(String educationLevel) {
    return remote.searchSchoolsByLevel(educationLevel, null);
  }

  @override
  Future<List<SchoolSearchEntity>> searchSchoolsByLevel(
    String educationLevel,
    String? query,
  ) {
    return remote.searchSchoolsByLevel(educationLevel, query);
  }
}
