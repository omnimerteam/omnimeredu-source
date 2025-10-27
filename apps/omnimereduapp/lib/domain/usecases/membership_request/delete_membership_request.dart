import '../../repositories/school/membership_request_repository.dart';

class DeleteMembershipRequestUseCase {
  final MembershipRequestRepository repository;

  DeleteMembershipRequestUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteMembershipRequest(id);
  }
}
