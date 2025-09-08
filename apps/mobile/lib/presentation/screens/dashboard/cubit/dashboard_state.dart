import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/dashboard_data_base_entity.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final String role;
  final DashboardDataBaseEntity data;
  final bool isFromCache;
  final bool isRefreshing;

  DashboardLoaded({
    required this.role,
    required this.data,
    this.isFromCache = false,
    this.isRefreshing = false,
  });

  DashboardLoaded copyWith({
    DashboardDataBaseEntity? data,
    bool? isFromCache,
    bool? isRefreshing,
  }) {
    return DashboardLoaded(
      role: role,
      data: data ?? this.data,
      isFromCache: isFromCache ?? this.isFromCache,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [role, data, isFromCache, isRefreshing];
}

class DashboardError extends DashboardState {
  final String message;
  final DashboardDataBaseEntity? cachedData;

  DashboardError(this.message, {this.cachedData});

  @override
  List<Object?> get props => [message, cachedData];
}
