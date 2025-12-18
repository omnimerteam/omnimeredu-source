import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/utils/either.dart';
import 'package:mobile/core/utils/api_utils.dart';
import 'package:mobile/domain/entities/class/class_entity.dart';
import 'package:mobile/domain/entities/class/class_selector_entity.dart';
import 'package:mobile/domain/entities/query/default_query_entity.dart';
import 'package:mobile/domain/repositories/school/class_repository.dart';
import 'package:mobile/data/models/school/class_model.dart';
import 'package:mobile/data/datasources/remote/school/class_remote_data_source.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassRemoteDataSource remoteDataSource;

  ClassRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ClassSelectorEntity>>> getClassesBySchool({
    required String schoolId,
  }) async {
    return safeApiCall(() async {
      return await remoteDataSource.getClassesBySchool(schoolId);
    });
  }

  @override
  Future<Either<Failure, List<ClassEntity>>> getAllClasses(
    DefaultQueryEntity query,
  ) async {
    return safeApiCall(() async {
      return await remoteDataSource.getAllClasses(query);
    });
  }

  @override
  Future<Either<Failure, ClassEntity>> createClass(
    ClassEntity createClassData,
  ) async {
    return safeApiCall(() async {
      final model = ClassModel(
        id: createClassData.id,
        name: createClassData.name,
        code: createClassData.code,
        schoolId: createClassData.schoolId,
        gradeId: createClassData.gradeId,
        maxStudents: createClassData.maxStudents,
        currentStudents: createClassData.currentStudents,
        baseFee: createClassData.baseFee,
        createdAt: createClassData.createdAt,
        updatedAt: createClassData.updatedAt,
      );
      return await remoteDataSource.createClass(model);
    });
  }

  @override
  Future<Either<Failure, ClassEntity>> getClassById(String id) async {
    return safeApiCall(() async {
      return await remoteDataSource.getClassById(id);
    });
  }

  @override
  Future<Either<Failure, ClassEntity>> updateClass(
    ClassEntity updateClassData,
  ) async {
    return safeApiCall(() async {
      final model = ClassModel(
        id: updateClassData.id,
        name: updateClassData.name,
        code: updateClassData.code,
        schoolId: updateClassData.schoolId,
        gradeId: updateClassData.gradeId,
        maxStudents: updateClassData.maxStudents,
        currentStudents: updateClassData.currentStudents,
        baseFee: updateClassData.baseFee,
        createdAt: updateClassData.createdAt,
        updatedAt: updateClassData.updatedAt,
      );
      return await remoteDataSource.updateClass(model);
    });
  }

  @override
  Future<Either<Failure, void>> deleteClass(String id) async {
    return safeApiCall(() async {
      await remoteDataSource.deleteClass(id);
    });
  }

  @override
  Future<Either<Failure, List<ClassSelectorEntity>>> searchClassesBySchool(
    String schoolId,
  ) async {
    return safeApiCall(() async {
      return await remoteDataSource.searchClassesBySchool(schoolId);
    });
  }
}
