import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/transfer_class_for_student_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';

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
