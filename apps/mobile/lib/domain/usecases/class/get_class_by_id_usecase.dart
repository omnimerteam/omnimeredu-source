import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';

class GetClassByIdUseCase {
  final ClassRepository repository;
  GetClassByIdUseCase(this.repository);

  Future<ClassEntity> call(String id) {
    return repository.getClassById(id);
  }
}
