// class_management_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';

abstract class ClassManagementEvent extends Equatable {
  const ClassManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadClassesEvent extends ClassManagementEvent {
  final int? page;
  final String? sort;

  const LoadClassesEvent({this.page, this.sort});

  @override
  List<Object?> get props => [page, sort];
}

// New event for handling sort string directly
class ChangeSortStringEvent extends ClassManagementEvent {
  final String sortString;

  const ChangeSortStringEvent(this.sortString);

  @override
  List<Object?> get props => [sortString];
}

// Keep the old event for backward compatibility if needed
class ChangeSortEvent extends ClassManagementEvent {
  final String sortField;

  const ChangeSortEvent(this.sortField);

  @override
  List<Object?> get props => [sortField];
}

class ChangePageEvent extends ClassManagementEvent {
  final int page;

  const ChangePageEvent(this.page);

  @override
  List<Object?> get props => [page];
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
  final String classId;

  const LoadClassForEditEvent(this.classId);

  @override
  List<Object?> get props => [classId];
}

class ShowCreateFormEvent extends ClassManagementEvent {}

class HideFormEvent extends ClassManagementEvent {}

class ResetFormEvent extends ClassManagementEvent {}
