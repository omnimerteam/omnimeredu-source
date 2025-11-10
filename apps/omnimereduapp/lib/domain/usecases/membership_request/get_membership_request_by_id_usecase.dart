import '../../entities/membership_request/membership_request_entity.dart';
import '../../repositories/school/membership_request_repository.dart';

class GetMembershipRequestByIdUseCase {
  final MembershipRequestRepository repository;

  GetMembershipRequestByIdUseCase(this.repository);

  Future<MembershipRequestEntity> call(String id) async {
    return await repository.getMemberRequestById(id);
  }
}
