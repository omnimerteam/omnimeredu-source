import '../../../core/network/api_response.dart';
import '../../entities/query/default_query_entity.dart';
import '../../entities/user/personnel_entity.dart';
import '../../repositories/user/personnel_repository.dart';

class GetAllPersonnelFromSchoolUseCase {
  final PersonnelRepository repository;

  GetAllPersonnelFromSchoolUseCase(this.repository);

  Future<ApiResponse<List<PersonnelEntity>>> call(
    DefaultQueryEntity query,
  ) async {
    return await repository.getAllPersonnelFromSchool(query);
  }
}
