import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_selector_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/student_repository.dart';

class GetStudentSelectorUseCase {
  StudentRepository repo;

  GetStudentSelectorUseCase(this.repo);

  Future<ApiResponse<List<StudentSelectorEntity>?>> call(
    String? gradeId,
  ) async {
    return await repo.getStudentSelector(gradeId);
  }
}
