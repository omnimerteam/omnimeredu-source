import 'package:mobile/domain/repositories/school/school_repository.dart';

import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/utils/either.dart';
import 'package:mobile/core/utils/api_utils.dart';
import 'package:mobile/domain/entities/school/school_selector_entity.dart';
import 'package:mobile/domain/entities/school/school_data_entity.dart';

import 'package:mobile/core/constants/enum_constant.dart';

import 'package:mobile/data/datasources/remote/school/school_remote_data_source.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final SchoolRemoteDataSource schoolRemoteDataSource;

  SchoolRepositoryImpl({required this.schoolRemoteDataSource});

  @override
  Future<Either<Failure, List<SchoolSelectorEntity>>> getSchoolsByLevel({
    required EducationSystemLevelsEnum educationLevel,
    String? search,
  }) async {
    return safeApiCall(() async {
      final schools = await schoolRemoteDataSource.getSchoolsByLevel(
        educationLevel: educationLevel,
        search: search,
      );
      return schools
          .map(
            (e) => SchoolSelectorEntity(
              id: e.id,
              name: e.name,
              code: e.code,
              address: e.address,
            ),
          )
          .toList();
    });
  }

  @override
  Future<Either<Failure, SchoolDataEntity?>>
  getSchoolDetailForSchoolAdmin() async {
    return safeApiCall(() async {
      return await schoolRemoteDataSource.getSchoolDetailForSchoolAdmin();
    });
  }

  @override
  Future<Either<Failure, SchoolDataEntity>> createSchool(
    SchoolDataEntity createSchoolData,
  ) async {
    return safeApiCall(() async {
      return await schoolRemoteDataSource.createSchool(createSchoolData);
    });
  }

  @override
  Future<Either<Failure, SchoolDataEntity>> updateSchool(
    SchoolDataEntity updateSchoolData,
  ) async {
    return safeApiCall(() async {
      return await schoolRemoteDataSource.updateSchool(updateSchoolData);
    });
  }

  @override
  Future<Either<Failure, void>> deleteSchool() async {
    return safeApiCall(() async {
      await schoolRemoteDataSource.deleteSchool();
    });
  }
}
