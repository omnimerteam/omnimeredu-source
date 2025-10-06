import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/attendance/attendance_class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';

abstract class AttendanceManagementState extends Equatable {
  const AttendanceManagementState();

  @override
  List<Object?> get props => [];
}

class AttendanceManagementInitial extends AttendanceManagementState {
  const AttendanceManagementInitial();
}

class AttendanceManagementLoading extends AttendanceManagementState {
  const AttendanceManagementLoading();
}

class AttendanceManagementError extends AttendanceManagementState {
  final String message;
  const AttendanceManagementError(this.message);
  @override
  List<Object?> get props => [message];
}

class AttendanceManagementLoaded extends AttendanceManagementState {
  final List<AttendanceClassEntity>? attendances;
  final bool hasReachedMax;
  final DefaultQueryEntity currentQuery;

  const AttendanceManagementLoaded({
    required this.attendances,
    required this.hasReachedMax,
    required this.currentQuery,
  });

  AttendanceManagementLoaded copyWith({
    List<AttendanceClassEntity>? attendances,
    bool? hasReachedMax,
    DefaultQueryEntity? currentQuery,
  }) {
    return AttendanceManagementLoaded(
      attendances: attendances ?? this.attendances,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentQuery: currentQuery ?? this.currentQuery,
    );
  }

  @override
  List<Object?> get props => [attendances, hasReachedMax, currentQuery];
}

class AttendanceManagementLoadingMore extends AttendanceManagementLoaded {
  const AttendanceManagementLoadingMore({
    required super.attendances,
    required super.currentQuery,
  }) : super(hasReachedMax: false);
}
