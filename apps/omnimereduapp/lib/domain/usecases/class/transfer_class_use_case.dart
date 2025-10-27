import '../../../core/network/api_response.dart';
import '../../entities/class/transfer_class_for_student_entity.dart';
import '../../repositories/school/class/class_repository.dart';

class TransferClassUseCase {
  final ClassRepository repository;

  TransferClassUseCase(this.repository);

  Future<ApiResponse<TransferClassForStudentEntity?>> transferClass(
    String classId,
    String targetClassId,
    List<String> studentIds,
  ) async {
    return await repository.transferClass(classId, targetClassId, studentIds);
  }
}
