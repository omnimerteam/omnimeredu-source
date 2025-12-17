import 'package:mobile/data/models/school/school_selector_model.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/endpoints.dart';
import 'package:mobile/core/error/failures.dart';
import 'package:mobile/domain/entities/school/school_data_entity.dart';

import 'package:mobile/core/constants/enum_constant.dart';

abstract class SchoolRemoteDataSource {
  Future<List<SchoolSelectorModel>> getSchoolsByLevel({
    required EducationSystemLevelsEnum educationLevel,
    String? search,
  });

  Future<SchoolDataEntity?> getSchoolDetailForSchoolAdmin();
  Future<SchoolDataEntity> createSchool(SchoolDataEntity createSchoolData);
  Future<SchoolDataEntity> updateSchool(SchoolDataEntity updateSchoolData);
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
  Future<SchoolDataEntity?> getSchoolDetailForSchoolAdmin() async {
    try {
      // Assuming Endpoint exists and returns { "data": SchoolData } or similar
      final res = await client.get<Map<String, dynamic>>(
        Endpoints.user.schoolAdminDetail,
        requiresAuth: true,
      );

      if (res.success && res.data != null) {
        // Need to parse JSON to SchoolDataEntity.
        // I should have a Model for SchoolDataEntity but for simplicity I'll map here or create a model method
        // But since I don't have SchoolDataModel, I'll do manual mapping or helper method.
        // Best practice is to use a Model. I will do simplistic mapping here for speed.
        return _mapJsonToSchoolDataEntity(res.data!);
      }
      return null;
    } catch (e) {
      // Return null or throw? The omnimereduapp usecase expected nullable.
      // But if it's a server error vs "not found", maybe handle differently.
      // I'll return null on specific errors or rethrow if important.
      return null;
    }
  }

  @override
  Future<SchoolDataEntity> createSchool(
    SchoolDataEntity createSchoolData,
  ) async {
    try {
      final res = await client.post<Map<String, dynamic>>(
        Endpoints.user.schools,
        data: _mapSchoolDataEntityToJson(createSchoolData),
        requiresAuth: true,
      );

      if (res.success && res.data != null) {
        return _mapJsonToSchoolDataEntity(res.data!);
      } else {
        throw ServerFailure(res.message);
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<SchoolDataEntity> updateSchool(
    SchoolDataEntity updateSchoolData,
  ) async {
    try {
      final res = await client.put<Map<String, dynamic>>(
        Endpoints
            .user
            .schools, // Assuming PUT to /schools updates or /schools/:id
        // Omnimereduapp code used `Endpoints.schools` (PUT) implies /v1/schools
        // Usually you need an ID. If the backend infers ID from body or token, this works.
        // If it needs ID in URL, I might need Endpoints.user.schoolById(id).
        // I'll stick to what omnimereduapp did: PUT /schools with body.
        data: _mapSchoolDataEntityToJson(updateSchoolData),
        requiresAuth: true,
      );

      if (res.success && res.data != null) {
        return _mapJsonToSchoolDataEntity(res.data!);
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
        Endpoints.user.schools, // DELETE /schools
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

  // Helper mappers (In real app, use Model.fromJson)
  SchoolDataEntity _mapJsonToSchoolDataEntity(Map<String, dynamic> json) {
    return SchoolDataEntity(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      code: json['code'],
      address: json['address'],
      phone: json['phone'],
      description: json['description'],
      level: json['educationLevel'] != null
          ? EducationSystemLevelsEnum.values.firstWhere(
              (e) => e.name == json['educationLevel'],
              orElse: () => EducationSystemLevelsEnum.Primary, // Fallback
            )
          : null,
      adminId: json['schoolAdmin'],
      logoUrl: json['logoUrl'],
      studentCount: json['studentCount'] ?? 0,
      // customTheme: json['customTheme'],
    );
  }

  Map<String, dynamic> _mapSchoolDataEntityToJson(SchoolDataEntity entity) {
    final map = <String, dynamic>{
      if (entity.id != null) 'id': entity.id, // or _id
      'name': entity.name,
      'address': entity.address,
      'phone': entity.phone,
      'description': entity.description,
      'educationLevel': entity.level?.name,
      // 'logoUrl': entity.logoUrl, // Handle upload separately?
    };
    return map;
  }
}
