import '../../../models/school/school_selector_model.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/endpoints.dart';
import '../../../../../core/error/failures.dart';

abstract class SchoolRemoteDataSource {
  Future<List<SchoolSelectorModel>> getSchoolsByLevel({
    required String educationLevel,
    String? search,
  });
}

class SchoolRemoteDataSourceImpl implements SchoolRemoteDataSource {
  final ApiClient client;

  SchoolRemoteDataSourceImpl(this.client);

  @override
  Future<List<SchoolSelectorModel>> getSchoolsByLevel({
    required String educationLevel,
    String? search,
  }) async {
    try {
      final response = await client.get<Map<String, dynamic>>(
        Endpoints.user.schools,
        query: {
          'educationLevel': educationLevel,
          if (search != null) 'search': search,
        },
        requiresAuth: false,
      );

      if (!response.success) {
        throw ServerFailure(response.message);
      }

      final data = response.data;
      if (data == null || data['schools'] == null) {
        return [];
      }

      final List<dynamic> schoolsJson = data['schools'];
      return schoolsJson
          .map((json) => SchoolSelectorModel.fromJson(json))
          .toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }
}
