import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/endpoints.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/data/models/school/class_selector_model.dart';
import 'package:mobile/data/models/school/class_model.dart';
import 'package:mobile/domain/entities/query/default_query_entity.dart';

abstract class ClassRemoteDataSource {
  Future<List<ClassSelectorModel>> getClassesBySchool({
    required String schoolId,
    String? grade,
  });

  Future<List<ClassModel>> getAllClasses(DefaultQueryEntity query);

  Future<ClassModel> createClass(ClassModel createClassData);

  Future<ClassModel> getClassById(String id);

  Future<ClassModel> updateClass(ClassModel updateClassData);

  Future<void> deleteClass(String id);
}

class ClassRemoteDataSourceImpl implements ClassRemoteDataSource {
  final ApiClient client;

  ClassRemoteDataSourceImpl(this.client);

  @override
  Future<List<ClassSelectorModel>> getClassesBySchool({
    required String schoolId,
    String? grade,
  }) async {
    try {
      final response = await client.get<Map<String, dynamic>>(
        Endpoints.user.classesBySchool(schoolId),
        query: {if (grade != null) 'grade': grade},
        requiresAuth: true,
      );

      if (!response.success) {
        throw ServerFailure(response.message);
      }

      final data = response.data;
      if (data == null) {
        return [];
      }

      final List<dynamic> classesJson = data['classes'];
      return classesJson
          .map((json) => ClassSelectorModel.fromJson(json))
          .toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<ClassModel>> getAllClasses(DefaultQueryEntity query) async {
    try {
      final response = await client.get<List<dynamic>>(
        Endpoints.user.classes,
        query: query.toQueryBuilder().build(),
      );

      if (!response.success) {
        throw ServerFailure(response.message);
      }

      final data = response.data;
      if (data == null) {
        return [];
      }

      return data.map((json) => ClassModel.fromJson(json)).toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ClassModel> createClass(ClassModel createClassData) async {
    try {
      final response = await client.post<Map<String, dynamic>>(
        Endpoints.user.classes,
        data: createClassData.toJson(),
      );

      if (!response.success) {
        throw ServerFailure(response.message);
      }

      return ClassModel.fromJson(response.data!);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ClassModel> getClassById(String id) async {
    try {
      final response = await client.get<Map<String, dynamic>>(
        Endpoints.user.classById(id),
      );

      if (!response.success) {
        throw ServerFailure(response.message);
      }

      return ClassModel.fromJson(response.data!);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ClassModel> updateClass(ClassModel updateClassData) async {
    try {
      final response = await client.put<Map<String, dynamic>>(
        Endpoints.user.classById(updateClassData.id),
        data: updateClassData.toJson(),
      );

      if (!response.success) {
        throw ServerFailure(response.message);
      }

      return ClassModel.fromJson(response.data!);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteClass(String id) async {
    try {
      final response = await client.delete<Map<String, dynamic>>(
        Endpoints.user.classById(id),
      );

      if (!response.success) {
        throw ServerFailure(response.message);
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }
}
