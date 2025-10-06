import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/membership_request_repository.dart';

class UpdateStatusMembershipRequestUseCase {
  final MembershipRequestRepository repository;

  UpdateStatusMembershipRequestUseCase(this.repository);

  Future<MembershipStatusEnum> call(
    String id,
    MembershipStatusEnum status,
  ) async {
    return await repository.updateStatusMemberRequest(id, status);
  }
}
