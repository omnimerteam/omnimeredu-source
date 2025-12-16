import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/endpoints.dart';
import '../../../../../core/error/failures.dart';
import '../../../models/school/class_selector_model.dart';

abstract class ClassRemoteDataSource {
  Future<List<ClassSelectorModel>> getClassesBySchool({
    required String schoolId,
    String? grade,
  });
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
        requiresAuth: false,
      );

      if (!response.success) {
        throw ServerFailure(response.message);
      }

      final data = response.data;
      if (data == null || data['classes'] == null) {
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
}
