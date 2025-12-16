import 'package:equatable/equatable.dart';
import 'package:mobile/domain/entities/grade/grade_entity.dart';
import 'package:mobile/domain/entities/query/default_query_entity.dart';

enum GradeManagementFormStatus { initial, loading, success, error }

abstract class GradeManagementState extends Equatable {
  const GradeManagementState();

  @override
  List<Object?> get props => [];
}

class GradeManagementInitial extends GradeManagementState {
  const GradeManagementInitial();
}

class GradeManagementLoading extends GradeManagementState {
  const GradeManagementLoading();
}

class GradeManagementError extends GradeManagementState {
  final String message;
  const GradeManagementError(this.message);

  @override
  List<Object?> get props => [message];
}

class GradeManagementLoaded extends GradeManagementState {
  final List<GradeEntity> grades;
  final bool hasReachedMax;
  final DefaultQueryEntity currentQuery;

  // Form handling state
  final bool isFormVisible;
  final bool isEditMode; // true = update, false = create
  final GradeEntity? gradeToEdit;
  final GradeManagementFormStatus formStatus;
  final String? formErrorMessage;

  const GradeManagementLoaded({
    required this.grades,
    required this.hasReachedMax,
    required this.currentQuery,
    this.isFormVisible = false,
    this.isEditMode = false,
    this.gradeToEdit,
    this.formStatus = GradeManagementFormStatus.initial,
    this.formErrorMessage,
  });

  GradeManagementLoaded copyWith({
    List<GradeEntity>? grades,
    bool? hasReachedMax,
    DefaultQueryEntity? currentQuery,
    bool? isFormVisible,
    bool? isEditMode,
    GradeEntity? gradeToEdit,
    bool clearGradeToEdit = false, // flag to force null
    GradeManagementFormStatus? formStatus,
    String? formErrorMessage,
    bool clearFormErrorMessage = false,
  }) {
    return GradeManagementLoaded(
      grades: grades ?? this.grades,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentQuery: currentQuery ?? this.currentQuery,
      isFormVisible: isFormVisible ?? this.isFormVisible,
      isEditMode: isEditMode ?? this.isEditMode,
      gradeToEdit: clearGradeToEdit ? null : (gradeToEdit ?? this.gradeToEdit),
      formStatus: formStatus ?? this.formStatus,
      formErrorMessage: clearFormErrorMessage
          ? null
          : (formErrorMessage ?? this.formErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
    grades,
    hasReachedMax,
    currentQuery,
    isFormVisible,
    isEditMode,
    gradeToEdit,
    formStatus,
    formErrorMessage,
  ];
}

class GradeManagementLoadingMore extends GradeManagementLoaded {
  const GradeManagementLoadingMore({
    required super.grades,
    required super.currentQuery,
    super.hasReachedMax = false,
  });
}

class GradeManagementFormLoading extends GradeManagementLoaded {
  const GradeManagementFormLoading({
    required super.grades,
    required super.currentQuery,
    super.hasReachedMax = false,
    super.isFormVisible,
    super.isEditMode,
    super.gradeToEdit,
  }) : super(formStatus: GradeManagementFormStatus.loading);
}
