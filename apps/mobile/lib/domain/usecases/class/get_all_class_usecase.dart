import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';

class GetAllClassUseCase {
  final ClassRepository repository;

  GetAllClassUseCase(this.repository);

  Future<List<ClassEntity>> call(DefaultQueryEntity query) {
    return repository.getAllClasses(query);
  }
}
