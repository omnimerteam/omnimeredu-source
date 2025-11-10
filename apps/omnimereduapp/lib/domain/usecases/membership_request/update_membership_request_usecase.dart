import '../../entities/membership_request/membership_request_entity.dart';
import '../../repositories/school/membership_request_repository.dart';

class UpdateMembershipRequestUseCase {
  final MembershipRequestRepository repository;

  UpdateMembershipRequestUseCase(this.repository);

  Future<void> call(MembershipRequestEntity updateMembershipRequestData) async {
    return await repository.updateMembershipRequest(
      updateMembershipRequestData,
    );
  }
}
