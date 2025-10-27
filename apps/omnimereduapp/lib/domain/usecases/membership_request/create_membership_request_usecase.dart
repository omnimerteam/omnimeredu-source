import '../../entities/membership_request/membership_request_entity.dart';
import '../../repositories/school/membership_request_repository.dart';

class CreateMembershipRequestUseCase {
  final MembershipRequestRepository repository;

  CreateMembershipRequestUseCase(this.repository);

  Future<void> call(MembershipRequestEntity createMembershipRequestData) async {
    return await repository.createMembershipRequest(
      createMembershipRequestData,
    );
  }
}
