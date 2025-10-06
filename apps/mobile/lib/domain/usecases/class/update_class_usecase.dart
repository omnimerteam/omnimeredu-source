import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';

class UpdateClassUseCase {
  final ClassRepository repository;
  UpdateClassUseCase(this.repository);

  Future<ClassEntity> call(ClassEntity updateClassData) async {
    return await repository.updateClass(updateClassData);
  }
}
