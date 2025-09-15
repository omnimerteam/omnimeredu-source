import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';

abstract class MembershipRequestRepository {
  Future<List<MembershipRequestEntity>> getAllMembershipRequest({
    int page,
    int limit,
    Map<String, String>? sort,
    Map<String, dynamic>? filter,
  });

  Future<MembershipRequestEntity> createMembershipRequest(
    MembershipRequestEntity createMembershipRequestData,
  );

  Future<MembershipRequestEntity> updateMembershipRequest(
    MembershipRequestEntity updateMembershipRequestData,
  );

  Future<void> deleteMembershipRequest(String id);

  Future<MembershipRequestEntity> getMemberRequestById(String id);

  Future<MembershipRequestEntity> updateStatusMemberRequest(
    String id,
    MembershipStatusEnum status,
  );
}
