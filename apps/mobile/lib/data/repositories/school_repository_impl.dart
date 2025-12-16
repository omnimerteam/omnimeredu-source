import 'package:mobile/domain/repositories/school/school_repository.dart';

import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/school/school_selector_entity.dart';
import '../../domain/entities/school/school_data_entity.dart';

import '../../core/constants/enum_constant.dart';

import '../datasources/remote/school/school_remote_data_source.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final SchoolRemoteDataSource schoolRemoteDataSource;

  SchoolRepositoryImpl({required this.schoolRemoteDataSource});

  @override
  Future<Either<Failure, List<SchoolSelectorEntity>>> getSchoolsByLevel({
    required EducationSystemLevelsEnum educationLevel,
    String? search,
  }) async {
    try {
      final schools = await schoolRemoteDataSource.getSchoolsByLevel(
        educationLevel: educationLevel,
        search: search,
      );
      // Map Model to Entity if needed.
      // Assuming SchoolSelectorModel extends or is compatible with SchoolSelectorEntity.
      // If not, explicit mapping is needed.
      // Mobile code usually has Models extend Entities.
      // checking compatibility: SchoolSelectorEntity props [id, name, code, address].
      // I'll assume it works or cast.
      final entities = schools
          .map(
            (e) => SchoolSelectorEntity(
              id: e.id,
              name: e.name,
              code: e.code,
              address: e.address,
            ),
          )
          .toList();
      return Right(entities);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<SchoolDataEntity?> getSchoolDetailForSchoolAdmin() async {
    // Direct call, exceptions handled by caller (Bloc)
    return await schoolRemoteDataSource.getSchoolDetailForSchoolAdmin();
  }

  @override
  Future<SchoolDataEntity> createSchool(
    SchoolDataEntity createSchoolData,
  ) async {
    return await schoolRemoteDataSource.createSchool(createSchoolData);
  }

  @override
  Future<SchoolDataEntity> updateSchool(
    SchoolDataEntity updateSchoolData,
  ) async {
    return await schoolRemoteDataSource.updateSchool(updateSchoolData);
  }

  @override
  Future<void> deleteSchool() async {
    return await schoolRemoteDataSource.deleteSchool();
  }
}
