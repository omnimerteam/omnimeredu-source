import 'package:equatable/equatable.dart';
import 'package:mobile/domain/entities/class/class_entity.dart';
import 'package:mobile/domain/entities/query/default_query_entity.dart';

abstract class ClassManagementState extends Equatable {
  const ClassManagementState();

  @override
  List<Object?> get props => [];
}

class ClassManagementInitial extends ClassManagementState {
  const ClassManagementInitial();
}

class ClassManagementLoading extends ClassManagementState {
  const ClassManagementLoading();
}

class ClassManagementLoaded extends ClassManagementState {
  final List<ClassEntity> classes;
  final bool hasReachedMax;
  final DefaultQueryEntity currentQuery;

  // Form
  final bool isFormVisible;
  final bool isEditMode;
  final ClassEntity? classToEdit;
  final ClassManagementFormStatus formStatus;
  final String? formErrorMessage;

  const ClassManagementLoaded({
    required this.classes,
    required this.hasReachedMax,
    required this.currentQuery,
    this.isFormVisible = false,
    this.isEditMode = false,
    this.classToEdit,
    this.formStatus = ClassManagementFormStatus.initial,
    this.formErrorMessage,
  });

  ClassManagementLoaded copyWith({
    List<ClassEntity>? classes,
    bool? hasReachedMax,
    DefaultQueryEntity? currentQuery,
    bool? isFormVisible,
    bool? isEditMode,
    ClassEntity? classToEdit,
    bool clearClassToEdit = false,
    ClassManagementFormStatus? formStatus,
    String? formErrorMessage,
    bool clearFormErrorMessage = false,
  }) {
    return ClassManagementLoaded(
      classes: classes ?? this.classes,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentQuery: currentQuery ?? this.currentQuery,
      isFormVisible: isFormVisible ?? this.isFormVisible,
      isEditMode: isEditMode ?? this.isEditMode,
      classToEdit: clearClassToEdit ? null : (classToEdit ?? this.classToEdit),
      formStatus: formStatus ?? this.formStatus,
      formErrorMessage: clearFormErrorMessage
          ? null
          : (formErrorMessage ?? this.formErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
    classes,
    hasReachedMax,
    currentQuery,
    isFormVisible,
    isEditMode,
    classToEdit,
    formStatus,
    formErrorMessage,
  ];
}

class ClassManagementError extends ClassManagementState {
  final String message;
  const ClassManagementError(this.message);

  @override
  List<Object?> get props => [message];
}

class ClassManagementLoadingMore extends ClassManagementState {
  final List<ClassEntity> classes;
  final DefaultQueryEntity currentQuery;

  const ClassManagementLoadingMore({
    required this.classes,
    required this.currentQuery,
  });

  @override
  List<Object?> get props => [classes, currentQuery];
}

class ClassManagementFormLoading extends ClassManagementState {
  final List<ClassEntity> classes;
  final DefaultQueryEntity currentQuery;
  final bool isFormVisible;
  final bool isEditMode;
  final ClassEntity? classToEdit;

  const ClassManagementFormLoading({
    required this.classes,
    required this.currentQuery,
    required this.isFormVisible,
    required this.isEditMode,
    this.classToEdit,
  });

  @override
  List<Object?> get props => [
    classes,
    currentQuery,
    isFormVisible,
    isEditMode,
    classToEdit,
  ];
}

enum ClassManagementFormStatus { initial, loading, success, error }
