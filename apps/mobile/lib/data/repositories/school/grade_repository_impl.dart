import 'package:mobile/core/error/failures.dart';
import 'package:mobile/core/utils/either.dart';
import 'package:mobile/domain/entities/grade/grade_entity.dart';
import 'package:mobile/domain/entities/query/default_query_entity.dart';
import 'package:mobile/domain/repositories/school/grade_repository.dart';
import 'package:mobile/data/datasources/remote/school/grade_remote_data_source.dart';
import 'package:mobile/data/models/grade/grade_model.dart';

class GradeRepositoryImpl implements GradeRepository {
  final GradeRemoteDataSource remoteDataSource;

  GradeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<GradeEntity>>> getAllGrades(
    DefaultQueryEntity query,
  ) async {
    try {
      final result = await remoteDataSource.getAllGrades(query);
      return Right(result);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GradeEntity>> createGrade(GradeEntity grade) async {
    try {
      final gradeModel = GradeModel.fromEntity(grade);
      final result = await remoteDataSource.createGrade(gradeModel);
      return Right(result);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GradeEntity>> updateGrade(GradeEntity grade) async {
    try {
      final gradeModel = GradeModel.fromEntity(grade);
      final result = await remoteDataSource.updateGrade(gradeModel);
      return Right(result);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGrade(String id) async {
    try {
      await remoteDataSource.deleteGrade(id);
      return const Right(null);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GradeEntity>> getGradeById(String id) async {
    try {
      final result = await remoteDataSource.getGradeById(id);
      return Right(result);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
