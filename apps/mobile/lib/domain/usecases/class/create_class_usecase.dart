import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';

class CreateClassUseCase {
  final ClassRepository repository;
  CreateClassUseCase(this.repository);

  Future<ClassEntity> call(ClassEntity createClassData) async {
    return await repository.createClass(createClassData);
  }
}
