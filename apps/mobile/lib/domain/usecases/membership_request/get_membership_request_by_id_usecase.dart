import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/membership_request_repository.dart';

class GetMembershipRequestByIdUseCase {
  final MembershipRequestRepository repository;

  GetMembershipRequestByIdUseCase(this.repository);

  Future<MembershipRequestEntity> call(String id) async {
    return await repository.getMemberRequestById(id);
  }
}
