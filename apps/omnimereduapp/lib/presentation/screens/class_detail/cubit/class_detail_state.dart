import 'package:equatable/equatable.dart';
import '../../../../domain/entities/view_model/class_detail_view_entity.dart';

abstract class ClassDetailState extends Equatable {
  const ClassDetailState();

  @override
  List<Object?> get props => [];
}

class ClassDetailInitial extends ClassDetailState {}

class ClassDetailLoading extends ClassDetailState {}

class ClassDetailLoaded extends ClassDetailState {
  final ClassDetailViewEntity classDetail;
  final List<StudentClassDetailEntity> filteredStudents;
  final String searchQuery;

  const ClassDetailLoaded({
    required this.classDetail,
    required this.filteredStudents,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [classDetail, filteredStudents, searchQuery];

  ClassDetailLoaded copyWith({
    ClassDetailViewEntity? classDetail,
    List<StudentClassDetailEntity>? filteredStudents,
    String? searchQuery,
  }) {
    return ClassDetailLoaded(
      classDetail: classDetail ?? this.classDetail,
      filteredStudents: filteredStudents ?? this.filteredStudents,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ClassDetailError extends ClassDetailState {
  final String message;

  const ClassDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
