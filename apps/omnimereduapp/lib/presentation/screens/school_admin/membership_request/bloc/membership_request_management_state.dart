import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/query/default_query_entity.dart';
import '../../../../../domain/entities/membership_request/membership_request_entity.dart';

enum MembershipRequestFormStatus { initial, loading, success, error }

abstract class MembershipRequestManagementState extends Equatable {
  const MembershipRequestManagementState();

  @override
  List<Object?> get props => [];
}

// Ban đầu
class MembershipRequestInitial extends MembershipRequestManagementState {
  const MembershipRequestInitial();
}

// Loading danh sách
class MembershipRequestLoading extends MembershipRequestManagementState {
  const MembershipRequestLoading();
}

// Loading thêm (pagination)
class MembershipRequestLoadingMore extends MembershipRequestManagementState {
  final List<MembershipRequestEntity> requests;
  final DefaultQueryEntity currentQuery;

  const MembershipRequestLoadingMore({
    required this.requests,
    required this.currentQuery,
  });

  @override
  List<Object?> get props => [requests, currentQuery];
}

// Loaded thành công
class MembershipRequestLoaded extends MembershipRequestManagementState {
  final List<MembershipRequestEntity> requests;
  final bool hasReachedMax;
  final DefaultQueryEntity currentQuery;
  final bool isFormVisible;
  final MembershipRequestFormStatus formStatus;
  final String? formErrorMessage;

  const MembershipRequestLoaded({
    required this.requests,
    required this.hasReachedMax,
    required this.currentQuery,
    this.isFormVisible = false,
    this.formStatus = MembershipRequestFormStatus.initial,
    this.formErrorMessage,
  });

  MembershipRequestLoaded copyWith({
    List<MembershipRequestEntity>? requests,
    bool? hasReachedMax,
    DefaultQueryEntity? currentQuery,
    bool? isFormVisible,
    MembershipRequestFormStatus? formStatus,
    String? formErrorMessage,
  }) {
    return MembershipRequestLoaded(
      requests: requests ?? this.requests,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentQuery: currentQuery ?? this.currentQuery,
      isFormVisible: isFormVisible ?? this.isFormVisible,
      formStatus: formStatus ?? this.formStatus,
      formErrorMessage: formErrorMessage ?? this.formErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    requests,
    hasReachedMax,
    currentQuery,
    isFormVisible,
    formStatus,
    formErrorMessage,
  ];
}

// Lỗi
class MembershipRequestError extends MembershipRequestManagementState {
  final String message;

  const MembershipRequestError(this.message);

  @override
  List<Object?> get props => [message];
}

// Form đang xử lý (update status)
class MembershipRequestFormLoading extends MembershipRequestManagementState {
  final List<MembershipRequestEntity> requests;
  final DefaultQueryEntity currentQuery;
  final bool isFormVisible;

  const MembershipRequestFormLoading({
    required this.requests,
    required this.currentQuery,
    required this.isFormVisible,
  });

  @override
  List<Object?> get props => [requests, currentQuery, isFormVisible];
}
