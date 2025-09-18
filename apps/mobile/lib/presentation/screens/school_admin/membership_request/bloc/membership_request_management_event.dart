import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';

abstract class MembershipRequestManagementEvent extends Equatable {
  const MembershipRequestManagementEvent();

  @override
  List<Object?> get props => [];
}

// Load danh sách ban đầu
class LoadMembershipRequestsEvent extends MembershipRequestManagementEvent {
  final DefaultQueryEntity? query;

  const LoadMembershipRequestsEvent({this.query});

  @override
  List<Object?> get props => [query];
}

// Refresh lại danh sách
class RefreshMembershipRequestsEvent extends MembershipRequestManagementEvent {}

// Load thêm khi scroll (pagination)
class LoadMoreMembershipRequestsEvent
    extends MembershipRequestManagementEvent {}

// Filter danh sách
class FilterMembershipRequestsEvent extends MembershipRequestManagementEvent {
  final Map<String, dynamic> filter;

  const FilterMembershipRequestsEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

// Sort danh sách
class SortMembershipRequestsEvent extends MembershipRequestManagementEvent {
  final Map<String, String> sort;

  const SortMembershipRequestsEvent(this.sort);

  @override
  List<Object?> get props => [sort];
}

// Update trạng thái 1 request
class UpdateStatusEvent extends MembershipRequestManagementEvent {
  final String requestId;
  final MembershipStatusEnum newStatus;

  const UpdateStatusEvent({required this.requestId, required this.newStatus});

  @override
  List<Object?> get props => [requestId, newStatus];
}
