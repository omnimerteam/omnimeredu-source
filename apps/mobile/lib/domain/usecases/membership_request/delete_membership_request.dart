import 'package:flutter_ios_android_platforms/domain/repositories/school/membership_request_repository.dart';

class DeleteMembershipRequestUseCase {
  final MembershipRequestRepository repository;

  DeleteMembershipRequestUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteMembershipRequest(id);
  }
}
