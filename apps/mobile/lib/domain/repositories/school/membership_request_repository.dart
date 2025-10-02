import 'package:flutter_ios_android_platforms/core/constants/enum_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';

abstract class MembershipRequestRepository {
  Future<List<MembershipRequestEntity>> getAllMembershipRequest(
    DefaultQueryEntity query,
  );

  Future<void> createMembershipRequest(
    MembershipRequestEntity createMembershipRequestData,
  );

  Future<void> updateMembershipRequest(
    MembershipRequestEntity updateMembershipRequestData,
  );

  Future<void> deleteMembershipRequest(String id);

  Future<MembershipRequestEntity> getMemberRequestById(String id);

  Future<MembershipStatusEnum> updateStatusMemberRequest(
    String id,
    MembershipStatusEnum status,
  );
}
