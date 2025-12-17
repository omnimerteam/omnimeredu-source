import 'package:equatable/equatable.dart';
import 'package:mobile/domain/entities/class/class_entity.dart';
import 'package:mobile/domain/entities/query/default_query_entity.dart';

abstract class ClassManagementEvent extends Equatable {
  const ClassManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadClassesEvent extends ClassManagementEvent {
  final DefaultQueryEntity? query;
  const LoadClassesEvent({this.query});

  @override
  List<Object?> get props => [query];
}

class RefreshClassesEvent extends ClassManagementEvent {}

class LoadMoreClassesEvent extends ClassManagementEvent {}

class FilterClassesEvent extends ClassManagementEvent {
  final Map<String, dynamic> filter;
  const FilterClassesEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SortClassesEvent extends ClassManagementEvent {
  final List<Map<String, String>> sort;
  const SortClassesEvent(this.sort);

  @override
  List<Object?> get props => [sort];
}

class CreateClassEvent extends ClassManagementEvent {
  final ClassEntity classEntity;
  const CreateClassEvent(this.classEntity);

  @override
  List<Object?> get props => [classEntity];
}

class UpdateClassEvent extends ClassManagementEvent {
  final ClassEntity classEntity;
  const UpdateClassEvent(this.classEntity);

  @override
  List<Object?> get props => [classEntity];
}

class DeleteClassEvent extends ClassManagementEvent {
  final String classId;
  const DeleteClassEvent(this.classId);

  @override
  List<Object?> get props => [classId];
}

class LoadClassForEditEvent extends ClassManagementEvent {
  final ClassEntity classEdit;
  const LoadClassForEditEvent(this.classEdit);

  @override
  List<Object?> get props => [classEdit];
}

class ShowCreateFormEvent extends ClassManagementEvent {}

class HideFormEvent extends ClassManagementEvent {}

class ResetFormEvent extends ClassManagementEvent {}

class ClearFormDataEvent extends ClassManagementEvent {}
