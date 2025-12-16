import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../domain/entities/class/class_entity.dart';
import '../../domain/entities/class/class_selector_entity.dart';
import '../../domain/entities/query/default_query_entity.dart';
import '../../domain/repositories/class_repository.dart';
import '../models/school/class_model.dart';
import '../datasources/remote/school/class_remote_data_source.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassRemoteDataSource remoteDataSource;

  ClassRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ClassSelectorEntity>>> getClassesBySchool({
    required String schoolId,
    String? grade,
  }) async {
    try {
      final classes = await remoteDataSource.getClassesBySchool(
        schoolId: schoolId,
        grade: grade,
      );
      return Right(classes);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ClassModel>>> getAllClasses(
    DefaultQueryEntity query,
  ) async {
    try {
      final classes = await remoteDataSource.getAllClasses(query);
      return Right(classes);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClassModel>> createClass(
    ClassEntity createClassData,
  ) async {
    try {
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
      final result = await remoteDataSource.createClass(model);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClassModel>> getClassById(String id) async {
    try {
      final result = await remoteDataSource.getClassById(id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClassModel>> updateClass(
    ClassEntity updateClassData,
  ) async {
    try {
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
      final result = await remoteDataSource.updateClass(model);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteClass(String id) async {
    try {
      await remoteDataSource.deleteClass(id);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
