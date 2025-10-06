import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';

abstract class AttendanceManagementEvent extends Equatable {
  const AttendanceManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadAttendancesEvent extends AttendanceManagementEvent {
  final DefaultQueryEntity? query;
  const LoadAttendancesEvent({this.query});

  @override
  List<Object?> get props => [query];
}

class RefreshAttendancesEvent extends AttendanceManagementEvent {}

class LoadMoreAttendancesEvent extends AttendanceManagementEvent {}

class FilterAttendancesEvent extends AttendanceManagementEvent {
  final Map<String, dynamic> filter;
  const FilterAttendancesEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SortAttendancesEvent extends AttendanceManagementEvent {
  final List<Map<String, String>> sort;
  const SortAttendancesEvent(this.sort);

  @override
  List<Object?> get props => [sort];
}

class SearchAttendancesEvent extends AttendanceManagementEvent {
  final String search;
  const SearchAttendancesEvent(this.search);

  @override
  List<Object?> get props => [search];
}

class DeleteAttendanceEvent extends AttendanceManagementEvent {
  final String attendanceId;
  const DeleteAttendanceEvent(this.attendanceId);

  @override
  List<Object?> get props => [attendanceId];
}
