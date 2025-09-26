import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/personnel_entity.dart';

abstract class PersonnelRepository {
  Future<ApiResponse<List<PersonnelEntity>>> getAllPersonnelFromSchool(
    DefaultQueryEntity query,
  );

  Future<ApiResponse<bool>> updateVerified(String personnelId, bool isVerified);

  Future<ApiResponse<void>> dismissPersonnel(String personnelId);
}
