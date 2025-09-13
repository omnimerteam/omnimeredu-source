import 'package:flutter_ios_android_platforms/core/app_constants.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_detail_view_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';

class GetAllClassDetailViewUseCase {
  final ClassRepository repository;

  GetAllClassDetailViewUseCase(this.repository);

  Future<List<ClassDetailViewEntity>> call(
    String sort, {
    int page = AppConstants.defaultPage,
    int limit = AppConstants.defaultLimit,
  }) {
    return repository.getAllClassDetailView(sort, page: page, limit: limit);
  }
}
