import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/personnel_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/personnel_repository.dart';

class GetAllPersonnelFromSchoolUseCase {
  final PersonnelRepository repository;

  GetAllPersonnelFromSchoolUseCase(this.repository);

  Future<ApiResponse<List<PersonnelEntity>>> call(
    DefaultQueryEntity query,
  ) async {
    return await repository.getAllPersonnelFromSchool(query);
  }
}
