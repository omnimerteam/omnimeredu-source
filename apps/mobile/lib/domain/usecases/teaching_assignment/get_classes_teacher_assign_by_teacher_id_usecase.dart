import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/teaching_assignment_repository.dart';

class GetClassesTeacherAssignByTeacherIdUseCase {
  final TeachingAssignmentRepository repository;

  GetClassesTeacherAssignByTeacherIdUseCase(this.repository);

  Future<ApiResponse<List<ClassSearchEntity>?>>
  getClassesTeacherAssignByTeacherId(String teacherId) async {
    return await repository.getClassesTeacherAssignByTeacherId(teacherId);
  }
}
