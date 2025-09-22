import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';

abstract class StudentManagementEvent extends Equatable {
  const StudentManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadStudentsEvent extends StudentManagementEvent {
  final DefaultQueryEntity? query;
  const LoadStudentsEvent({this.query});

  @override
  List<Object?> get props => [query];
}

class RefreshStudentsEvent extends StudentManagementEvent {}

class LoadMoreStudentsEvent extends StudentManagementEvent {}

class FilterStudentsEvent extends StudentManagementEvent {
  final Map<String, dynamic> filter;
  const FilterStudentsEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SortStudentsEvent extends StudentManagementEvent {
  final List<Map<String, String>> sort;
  const SortStudentsEvent(this.sort);

  @override
  List<Object?> get props => [sort];
}

class SearchStudentsEvent extends StudentManagementEvent {
  final String search;
  const SearchStudentsEvent(this.search);

  @override
  List<Object?> get props => [search];
}

class CreateStudentEvent extends StudentManagementEvent {
  final StudentEntity studentEntity;
  const CreateStudentEvent(this.studentEntity);

  @override
  List<Object?> get props => [studentEntity];
}

class UpdateStudentEvent extends StudentManagementEvent {
  final StudentEntity studentEntity;
  const UpdateStudentEvent(this.studentEntity);

  @override
  List<Object?> get props => [studentEntity];
}

class DeleteStudentEvent extends StudentManagementEvent {
  final String studentId;
  const DeleteStudentEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}

class LoadStudentByIdEvent extends StudentManagementEvent {
  final String studentId;
  const LoadStudentByIdEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}

class LoadStudentForEditEvent extends StudentManagementEvent {
  final StudentEntity studentToEdit;
  const LoadStudentForEditEvent(this.studentToEdit);

  @override
  List<Object?> get props => [studentToEdit];
}

class ShowCreateFormEvent extends StudentManagementEvent {}

class HideFormEvent extends StudentManagementEvent {}

class ResetFormEvent extends StudentManagementEvent {}

class ClearFormDataEvent extends StudentManagementEvent {}

class ShowStudentDetailsEvent extends StudentManagementEvent {
  final StudentEntity student;
  const ShowStudentDetailsEvent(this.student);

  @override
  List<Object?> get props => [student];
}

class HideStudentDetailsEvent extends StudentManagementEvent {}
