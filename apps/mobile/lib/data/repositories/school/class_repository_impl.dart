import '../../../core/error/failures.dart';
import '../../../core/utils/either.dart';
import '../../../core/utils/api_utils.dart';
import '../../../domain/entities/class/class_entity.dart';
import '../../../domain/entities/class/class_selector_entity.dart';
import '../../../domain/entities/query/default_query_entity.dart';
import '../../../domain/repositories/school/class_repository.dart';
import '../../models/school/class_model.dart';
import '../../datasources/remote/school/class_remote_data_source.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassRemoteDataSource remoteDataSource;

  ClassRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ClassSelectorEntity>>> getClassesBySchool({
    required String schoolId,
    String? grade,
  }) async {
    return safeApiCall(() async {
      return await remoteDataSource.getClassesBySchool(
        schoolId: schoolId,
        grade: grade,
      );
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
        grade: createClassData.grade,
        level: createClassData.level,
        maxStudents: createClassData.maxStudents,
        currentStudents: createClassData.currentStudents,
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
        grade: updateClassData.grade,
        level: updateClassData.level,
        maxStudents: updateClassData.maxStudents,
        currentStudents: updateClassData.currentStudents,
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
}
