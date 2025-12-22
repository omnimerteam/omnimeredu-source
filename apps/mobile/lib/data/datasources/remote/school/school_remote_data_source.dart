import 'package:mobile/data/models/school/school_selector_model.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/endpoints.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/data/models/school/school_data_model.dart';

import 'package:mobile/core/constants/enum_constant.dart';

abstract class SchoolRemoteDataSource {
  Future<List<SchoolSelectorModel>> getSchoolsByLevel({
    required EducationSystemLevelsEnum educationLevel,
    String? search,
  });

  Future<SchoolDataModel?> getSchoolDetailForSchoolAdmin();
  Future<SchoolDataModel> createSchool(SchoolDataModel createSchoolData);
  Future<SchoolDataModel> updateSchool(SchoolDataModel updateSchoolData);
  Future<void> deleteSchool();
}

class SchoolRemoteDataSourceImpl implements SchoolRemoteDataSource {
  final ApiClient client;

  SchoolRemoteDataSourceImpl(this.client);

  @override
  Future<List<SchoolSelectorModel>> getSchoolsByLevel({
    required EducationSystemLevelsEnum educationLevel,
    String? search,
  }) async {
    try {
      final response = await client.get<dynamic>(
        Endpoints.user.schools,
        query: {
          'educationLevel': educationLevel.name,
          if (search != null) 'search': search,
        },
        requiresAuth: false,
      );

      if (!response.success) {
        throw ServerFailure(response.message);
      }

      final data = response.data;
      if (data == null) {
        return [];
      }

      final List<dynamic> schoolsJson = data is List
          ? data
          : (data['schools'] ?? []);
      return schoolsJson
          .map((json) => SchoolSelectorModel.fromJson(json))
          .toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<SchoolDataModel?> getSchoolDetailForSchoolAdmin() async {
    try {
      final res = await client.get<Map<String, dynamic>>(
        Endpoints.user.schoolAdminDetail,
        requiresAuth: true,
      );

      if (res.success && res.data != null) {
        return SchoolDataModel.fromJson(res.data!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<SchoolDataModel> createSchool(SchoolDataModel createSchoolData) async {
    try {
      final res = await client.post<Map<String, dynamic>>(
        Endpoints.user.schools,
        data: createSchoolData.toJson(),
        requiresAuth: true,
      );

      if (res.success && res.data != null) {
        return SchoolDataModel.fromJson(res.data!);
      } else {
        throw ServerFailure(res.message);
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<SchoolDataModel> updateSchool(SchoolDataModel updateSchoolData) async {
    try {
      final res = await client.put<Map<String, dynamic>>(
        Endpoints.user.schools,
        data: updateSchoolData.toJson(),
        requiresAuth: true,
      );

      if (res.success && res.data != null) {
        return SchoolDataModel.fromJson(res.data!);
      } else {
        throw ServerFailure(res.message);
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteSchool() async {
    try {
      final res = await client.delete<void>(
        Endpoints.user.schools,
        requiresAuth: true,
      );

      if (!res.success) {
        throw ServerFailure(res.message);
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }
}
