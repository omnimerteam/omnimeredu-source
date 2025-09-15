import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';

abstract class MembershipRequestManagementState extends Equatable {
  const MembershipRequestManagementState();

  @override
  List<Object?> get props => [];
}

class MembershipRequestInitial extends MembershipRequestManagementState {
  const MembershipRequestInitial();
}

class MembershipRequestLoading extends MembershipRequestManagementState {
  const MembershipRequestLoading();
}

class MembershipRequestLoaded extends MembershipRequestManagementState {
  final List<MembershipRequestEntity> requests;
  final bool hasReachedMax;
  final int currentPage;
  final Map<String, String> currentSort;
  final Map<String, dynamic> currentFilter;

  const MembershipRequestLoaded({
    required this.requests,
    required this.hasReachedMax,
    required this.currentPage,
    required this.currentSort,
    required this.currentFilter,
  });

  MembershipRequestLoaded copyWith({
    List<MembershipRequestEntity>? requests,
    bool? hasReachedMax,
    int? currentPage,
    Map<String, String>? currentSort,
    Map<String, dynamic>? currentFilter,
  }) {
    return MembershipRequestLoaded(
      requests: requests ?? this.requests,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      currentSort: currentSort ?? this.currentSort,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }

  @override
  List<Object?> get props => [
    requests,
    hasReachedMax,
    currentPage,
    currentSort,
    currentFilter,
  ];
}

class MembershipRequestError extends MembershipRequestManagementState {
  final String message;

  const MembershipRequestError(this.message);

  @override
  List<Object?> get props => [message];
}

class MembershipRequestLoadingMore extends MembershipRequestManagementState {
  final List<MembershipRequestEntity> requests;
  final Map<String, String> currentSort;
  final Map<String, dynamic> currentFilter;

  const MembershipRequestLoadingMore({
    required this.requests,
    required this.currentSort,
    required this.currentFilter,
  });

  @override
  List<Object?> get props => [requests, currentSort, currentFilter];
}

class MembershipRequestUpdatingStatus extends MembershipRequestManagementState {
  final List<MembershipRequestEntity> requests;
  final String updatingRequestId;

  const MembershipRequestUpdatingStatus({
    required this.requests,
    required this.updatingRequestId,
  });

  @override
  List<Object?> get props => [requests, updatingRequestId];
}
