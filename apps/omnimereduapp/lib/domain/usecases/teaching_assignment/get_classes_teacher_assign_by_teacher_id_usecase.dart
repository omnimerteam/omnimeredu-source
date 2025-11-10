import '../../../core/network/api_response.dart';
import '../../entities/class/class_search_entity.dart';
import '../../repositories/school/class/teaching_assignment_repository.dart';

class GetClassesTeacherAssignByTeacherIdUseCase {
  final TeachingAssignmentRepository repository;

  GetClassesTeacherAssignByTeacherIdUseCase(this.repository);

  Future<ApiResponse<List<ClassSearchEntity>?>>
  getClassesTeacherAssignByTeacherId(String teacherId) async {
    return await repository.getClassesTeacherAssignByTeacherId(teacherId);
  }
}
