import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/endpoints.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/school/school_entity.dart';
import '../../../../../domain/entities/school/class_entity.dart';

abstract class SchoolRemoteDataSource {
  Future<List<SchoolEntity>> getSchoolsByLevel({
    required String educationLevel,
    String? search,
  });
  Future<List<ClassEntity>> getClassesBySchool({
    required String schoolId,
    String? grade,
  });
}

class SchoolRemoteDataSourceImpl implements SchoolRemoteDataSource {
  final ApiClient client;

  SchoolRemoteDataSourceImpl(this.client);

  @override
  Future<List<SchoolEntity>> getSchoolsByLevel({
    required String educationLevel,
    String? search,
  }) async {
    try {
      final response = await client.get<Map<String, dynamic>>(
        Endpoints.user.getSchools,
        queryParameters: {
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
      return schoolsJson.map((json) => _mapSchoolFromJson(json)).toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<ClassEntity>> getClassesBySchool({
    required String schoolId,
    String? grade,
  }) async {
    try {
      final response = await client.get<Map<String, dynamic>>(
        Endpoints.user.getClassesBySchool(schoolId),
        queryParameters: {
          if (grade != null) 'grade': grade,
        },
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
      return classesJson.map((json) => _mapClassFromJson(json)).toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  SchoolEntity _mapSchoolFromJson(Map<String, dynamic> json) {
    return SchoolEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      level: EducationSystemLevelsEnum.fromString(json['level']),
      logoUrl: json['logoUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  ClassEntity _mapClassFromJson(Map<String, dynamic> json) {
    return ClassEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      schoolId: json['schoolId'] as String,
      grade: EducationGradesEnum.fromString(json['grade']),
      level: EducationSystemLevelsEnum.fromString(json['level']),
      maxStudents: json['maxStudents'] as int?,
      currentStudents: json['currentStudents'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
}