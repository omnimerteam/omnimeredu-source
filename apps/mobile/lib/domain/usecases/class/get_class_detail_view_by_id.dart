import 'package:flutter_ios_android_platforms/domain/entities/view_model/class_detail_view_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';

class GetClassDetailViewByIdUseCase {
  final ClassRepository repository;
  GetClassDetailViewByIdUseCase(this.repository);

  Future<ClassDetailViewEntity> call(String id) async {
    return await repository.getClassDetailViewById(id);
  }
}
