import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/membership_request_repository.dart';

class CreateMembershipRequestUseCase {
  final MembershipRequestRepository repository;

  CreateMembershipRequestUseCase(this.repository);

  Future<MembershipRequestEntity> call(
    MembershipRequestEntity createMembershipRequestData,
  ) {
    return repository.createMembershipRequest(createMembershipRequestData);
  }
}
