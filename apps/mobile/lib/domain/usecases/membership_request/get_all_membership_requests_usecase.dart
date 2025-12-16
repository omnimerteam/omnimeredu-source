import '../../../core/usecases/usecase.dart';
import '../../entities/query/default_query_entity.dart';
import '../../entities/school/membership_request_entity.dart';
import '../../repositories/school/membership_request_repository.dart';

class GetAllMembershipRequestsUseCase
    extends UseCase<List<MembershipRequestEntity>, DefaultQueryEntity> {
  final MembershipRequestRepository repository;

  GetAllMembershipRequestsUseCase(this.repository);

  @override
  Future<List<MembershipRequestEntity>> call(DefaultQueryEntity params) async {
    return await repository.getAllMembershipRequest(params);
  }
}
