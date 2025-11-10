import '../../../core/network/api_response.dart';
import '../../entities/query/default_query_entity.dart';
import '../../entities/user/personnel_entity.dart';

abstract class PersonnelRepository {
  Future<ApiResponse<List<PersonnelEntity>>> getAllPersonnelFromSchool(
    DefaultQueryEntity query,
  );

  Future<ApiResponse<bool>> updateVerified(String personnelId, bool isVerified);

  Future<ApiResponse<void>> dismissPersonnel(String personnelId);

  Future<ApiResponse<void>> updateAvatar(String avatarPath, String avatarUrl);
}
