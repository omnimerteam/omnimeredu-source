import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';

abstract class StudentManagementState extends Equatable {
  const StudentManagementState();

  @override
  List<Object?> get props => [];
}

class StudentManagementInitial extends StudentManagementState {
  const StudentManagementInitial();
}

class StudentManagementLoading extends StudentManagementState {
  const StudentManagementLoading();
}

class StudentManagementLoaded extends StudentManagementState {
  final List<StudentEntity> students;
  final bool hasReachedMax;
  final DefaultQueryEntity currentQuery;

  // Form
  final bool isFormVisible;
  final bool isEditMode;
  final StudentEntity? studentToEdit;
  final StudentManagementFormStatus formStatus;
  final String? formErrorMessage;

  // Student Details
  final bool isDetailsVisible;
  final StudentEntity? selectedStudentDetails;
  final bool isLoadingDetails;
  final String? detailsErrorMessage;

  const StudentManagementLoaded({
    required this.students,
    required this.hasReachedMax,
    required this.currentQuery,
    this.isFormVisible = false,
    this.isEditMode = false,
    this.studentToEdit,
    this.formStatus = StudentManagementFormStatus.initial,
    this.formErrorMessage,
    this.isDetailsVisible = false,
    this.selectedStudentDetails,
    this.isLoadingDetails = false,
    this.detailsErrorMessage,
  });

  StudentManagementLoaded copyWith({
    List<StudentEntity>? students,
    bool? hasReachedMax,
    DefaultQueryEntity? currentQuery,
    bool? isFormVisible,
    bool? isEditMode,
    StudentEntity? studentToEdit,
    bool clearStudentToEdit = false,
    StudentManagementFormStatus? formStatus,
    String? formErrorMessage,
    bool clearFormErrorMessage = false,
    bool? isDetailsVisible,
    StudentEntity? selectedStudentDetails,
    bool clearSelectedStudentDetails = false,
    bool? isLoadingDetails,
    String? detailsErrorMessage,
    bool clearDetailsErrorMessage = false,
  }) {
    return StudentManagementLoaded(
      students: students ?? this.students,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentQuery: currentQuery ?? this.currentQuery,
      isFormVisible: isFormVisible ?? this.isFormVisible,
      isEditMode: isEditMode ?? this.isEditMode,
      studentToEdit: clearStudentToEdit
          ? null
          : (studentToEdit ?? this.studentToEdit),
      formStatus: formStatus ?? this.formStatus,
      formErrorMessage: clearFormErrorMessage
          ? null
          : (formErrorMessage ?? this.formErrorMessage),
      isDetailsVisible: isDetailsVisible ?? this.isDetailsVisible,
      selectedStudentDetails: clearSelectedStudentDetails
          ? null
          : (selectedStudentDetails ?? this.selectedStudentDetails),
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      detailsErrorMessage: clearDetailsErrorMessage
          ? null
          : (detailsErrorMessage ?? this.detailsErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
    students,
    hasReachedMax,
    currentQuery,
    isFormVisible,
    isEditMode,
    studentToEdit,
    formStatus,
    formErrorMessage,
    isDetailsVisible,
    selectedStudentDetails,
    isLoadingDetails,
    detailsErrorMessage,
  ];
}

class StudentManagementError extends StudentManagementState {
  final String message;
  const StudentManagementError(this.message);

  @override
  List<Object?> get props => [message];
}

class StudentManagementLoadingMore extends StudentManagementState {
  final List<StudentEntity> students;
  final DefaultQueryEntity currentQuery;

  const StudentManagementLoadingMore({
    required this.students,
    required this.currentQuery,
  });

  @override
  List<Object?> get props => [students, currentQuery];
}

class StudentManagementFormLoading extends StudentManagementState {
  final List<StudentEntity> students;
  final DefaultQueryEntity currentQuery;
  final bool isFormVisible;
  final bool isEditMode;
  final StudentEntity? studentToEdit;

  const StudentManagementFormLoading({
    required this.students,
    required this.currentQuery,
    required this.isFormVisible,
    required this.isEditMode,
    this.studentToEdit,
  });

  @override
  List<Object?> get props => [
    students,
    currentQuery,
    isFormVisible,
    isEditMode,
    studentToEdit,
  ];
}

enum StudentManagementFormStatus { initial, loading, success, error }
