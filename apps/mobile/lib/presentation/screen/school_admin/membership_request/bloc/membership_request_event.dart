import 'package:equatable/equatable.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/query/default_query_entity.dart';

abstract class MembershipRequestEvent extends Equatable {
  const MembershipRequestEvent();

  @override
  List<Object?> get props => [];
}

// Load danh sách ban đầu
class LoadMembershipRequestsEvent extends MembershipRequestEvent {
  final DefaultQueryEntity? query;

  const LoadMembershipRequestsEvent({this.query});

  @override
  List<Object?> get props => [query];
}

// Refresh lại danh sách
class RefreshMembershipRequestsEvent extends MembershipRequestEvent {}

// Load thêm khi scroll (pagination)
class LoadMoreMembershipRequestsEvent extends MembershipRequestEvent {}

// Filter danh sách
class FilterMembershipRequestsEvent extends MembershipRequestEvent {
  final Map<String, dynamic> filter;

  const FilterMembershipRequestsEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

// Sort danh sách
class SortMembershipRequestsEvent extends MembershipRequestEvent {
  final Map<String, String> sort;

  const SortMembershipRequestsEvent(this.sort);

  @override
  List<Object?> get props => [sort];
}

// Update trạng thái 1 request
class UpdateStatusEvent extends MembershipRequestEvent {
  final String requestId;
  final MembershipStatusEnum newStatus;

  const UpdateStatusEvent({required this.requestId, required this.newStatus});

  @override
  List<Object?> get props => [requestId, newStatus];
}
