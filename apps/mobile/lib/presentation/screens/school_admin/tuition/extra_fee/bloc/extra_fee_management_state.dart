import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/tuition/extra_fee_entity.dart';

enum ExtraFeeStatus { initial, loading, success, error }

abstract class ExtraFeeManagementState extends Equatable {
  const ExtraFeeManagementState();

  @override
  List<Object?> get props => [];
}

/// --- Trạng thái ban đầu ---
class ExtraFeeManagementInitial extends ExtraFeeManagementState {
  const ExtraFeeManagementInitial();
}

/// --- Đang loading ---
class ExtraFeeManagementLoading extends ExtraFeeManagementState {
  const ExtraFeeManagementLoading();
}

/// --- Đã tải danh sách ---
class ExtraFeeManagementLoaded extends ExtraFeeManagementState {
  final List<ExtraFeeEntity> extraFees;
  final bool hasReachedMax;
  final DefaultQueryEntity currentQuery;
  final ExtraFeeStatus status;
  final bool lastActionSuccess;
  final String? message;

  // Chi tiết
  final ExtraFeeEntity? selectedExtraFee;
  final bool isDetailsVisible;
  final bool isLoadingDetails;

  const ExtraFeeManagementLoaded({
    required this.extraFees,
    required this.hasReachedMax,
    required this.currentQuery,
    this.status = ExtraFeeStatus.initial,
    this.lastActionSuccess = true,
    this.message,
    this.selectedExtraFee,
    this.isDetailsVisible = false,
    this.isLoadingDetails = false,
  });

  ExtraFeeManagementLoaded copyWith({
    List<ExtraFeeEntity>? extraFees,
    bool? hasReachedMax,
    DefaultQueryEntity? currentQuery,
    ExtraFeeStatus? status,
    bool? lastActionSuccess,
    String? message,
    ExtraFeeEntity? selectedExtraFee,
    bool? isDetailsVisible,
    bool? isLoadingDetails,
  }) {
    return ExtraFeeManagementLoaded(
      extraFees: extraFees ?? this.extraFees,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentQuery: currentQuery ?? this.currentQuery,
      status: status ?? this.status,
      lastActionSuccess: lastActionSuccess ?? this.lastActionSuccess,
      message: message ?? this.message,
      selectedExtraFee: selectedExtraFee ?? this.selectedExtraFee,
      isDetailsVisible: isDetailsVisible ?? this.isDetailsVisible,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
    );
  }

  @override
  List<Object?> get props => [
    extraFees,
    hasReachedMax,
    currentQuery,
    status,
    lastActionSuccess,
    message,
    selectedExtraFee,
    isDetailsVisible,
    isLoadingDetails,
  ];
}

/// --- Đang load thêm ---
class ExtraFeeManagementLoadingMore extends ExtraFeeManagementLoaded {
  const ExtraFeeManagementLoadingMore({
    required super.extraFees,
    required super.currentQuery,
  }) : super(hasReachedMax: false);
}

/// --- Lỗi ---
class ExtraFeeManagementError extends ExtraFeeManagementState {
  final String message;
  const ExtraFeeManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
