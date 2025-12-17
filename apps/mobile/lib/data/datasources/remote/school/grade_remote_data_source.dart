import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/error/failures.dart';
import '../../../../domain/entities/query/default_query_entity.dart';
import '../../../models/grade/grade_model.dart';

abstract class GradeRemoteDataSource {
  Future<List<GradeModel>> getAllGrades(DefaultQueryEntity query);
  Future<GradeModel> createGrade(GradeModel grade);
  Future<GradeModel> updateGrade(GradeModel grade);
  Future<void> deleteGrade(String id);
  Future<GradeModel> getGradeById(String id);
}

class GradeRemoteDataSourceImpl implements GradeRemoteDataSource {
  final ApiClient client;

  GradeRemoteDataSourceImpl(this.client);

  @override
  Future<List<GradeModel>> getAllGrades(DefaultQueryEntity query) async {
    try {
      final queryParams = query.toQueryBuilder().build();

      final response = await client.get<Map<String, dynamic>>(
        Endpoints.user.grades,
        query: queryParams,
      );

      if (!response.success) {
        throw ServerFailure(response.message);
      }

      final data = response.data;
      if (data == null || data['items'] == null) {
        return [];
      }

      return (data['items'] as List)
          .map((item) => GradeModel.fromJson(item))
          .toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<GradeModel> createGrade(GradeModel grade) async {
    try {
      final response = await client.post<Map<String, dynamic>>(
        Endpoints.user.grades,
        data: grade.toJson(),
      );

      if (!response.success) {
        throw ServerFailure(response.message);
      }

      if (response.data == null) {
        throw const ServerFailure("No data returned from create grade");
      }

      return GradeModel.fromJson(response.data!);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<GradeModel> updateGrade(GradeModel grade) async {
    try {
      if (grade.id == null) throw const ServerFailure("Grade ID is null");

      final response = await client.put<Map<String, dynamic>>(
        Endpoints.user.gradeById(grade.id!),
        data: grade.toJson(),
      );

      if (!response.success) {
        throw ServerFailure(response.message);
      }

      if (response.data == null) {
        throw const ServerFailure("No data returned from update grade");
      }

      return GradeModel.fromJson(response.data!);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteGrade(String id) async {
    try {
      final response = await client.delete(Endpoints.user.gradeById(id));

      if (!response.success) {
        throw ServerFailure(response.message);
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<GradeModel> getGradeById(String id) async {
    try {
      final response = await client.get<Map<String, dynamic>>(
        Endpoints.user.gradeById(id),
      );

      if (!response.success) {
        throw ServerFailure(response.message);
      }

      if (response.data == null) {
        throw const ServerFailure("No data returned from get grade");
      }

      return GradeModel.fromJson(response.data!);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }
}
