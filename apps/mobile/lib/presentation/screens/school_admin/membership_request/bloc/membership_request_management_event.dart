import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';

abstract class MembershipRequestManagementEvent extends Equatable {
  const MembershipRequestManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadMembershipRequestsEvent extends MembershipRequestManagementEvent {
  const LoadMembershipRequestsEvent();
}

class RefreshMembershipRequestsEvent extends MembershipRequestManagementEvent {
  const RefreshMembershipRequestsEvent();
}

class LoadMoreMembershipRequestsEvent extends MembershipRequestManagementEvent {
  const LoadMoreMembershipRequestsEvent();
}

class FilterMembershipRequestsEvent extends MembershipRequestManagementEvent {
  final Map<String, dynamic> filter;

  const FilterMembershipRequestsEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SortMembershipRequestsEvent extends MembershipRequestManagementEvent {
  final Map<String, String> sort;

  const SortMembershipRequestsEvent(this.sort);

  @override
  List<Object?> get props => [sort];
}

class UpdateStatusEvent extends MembershipRequestManagementEvent {
  final String requestId;
  final MembershipStatusEnum newStatus;

  const UpdateStatusEvent(this.requestId, this.newStatus);

  @override
  List<Object?> get props => [requestId, newStatus];
}
