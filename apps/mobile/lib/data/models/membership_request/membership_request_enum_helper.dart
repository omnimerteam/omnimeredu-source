import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';

MembershipActionEnum actionFromString(String action) {
  return MembershipActionEnum.values.firstWhere(
    (e) => e.name == action,
    orElse: () => MembershipActionEnum.Enroll,
  );
}

MembershipRoleEnum roleFromString(String role) {
  return MembershipRoleEnum.values.firstWhere(
    (e) => e.name == role,
    orElse: () => MembershipRoleEnum.Student,
  );
}

MembershipStatusEnum statusFromString(String status) {
  return MembershipStatusEnum.values.firstWhere(
    (e) => e.name == status,
    orElse: () => MembershipStatusEnum.Pending,
  );
}
