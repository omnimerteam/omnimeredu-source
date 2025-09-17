import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_detail_view_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';

class GetAllClassDetailViewUseCase {
  final ClassRepository repository;

  GetAllClassDetailViewUseCase(this.repository);

  Future<List<ClassDetailViewEntity>> call({
    int page = AppConstants.defaultPage,
    int limit = AppConstants.defaultLimit,
    Map<String, String>? sort,
    Map<String, dynamic>? filter,
  }) {
    return repository.getAllClassDetailView(
      page: page,
      limit: limit,
      sort: sort,
      filter: filter,
    );
  }
}
