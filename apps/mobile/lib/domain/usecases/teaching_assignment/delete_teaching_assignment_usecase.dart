import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/teaching_assignment_repository.dart';

class DeleteTeachingAssignmentUseCase {
  final TeachingAssignmentRepository repository;

  DeleteTeachingAssignmentUseCase(this.repository);

  Future<ApiResponse<void>> call(String id) async {
    return await repository.deleteTeachingAssignment(id);
  }
}
