// class_management_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_detail_view_entity.dart';

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
  final List<ClassDetailViewEntity> classes;
  final bool hasReachedMax;
  final int currentPage;
  final Map<String, String> currentSort;
  final Map<String, dynamic> currentFilter;

  // Form related
  final bool isFormVisible;
  final bool isEditMode;
  final ClassEntity? classToEdit;
  final ClassManagementFormStatus formStatus;
  final String? formErrorMessage;

  const ClassManagementLoaded({
    required this.classes,
    required this.hasReachedMax,
    required this.currentPage,
    required this.currentSort,
    required this.currentFilter,
    this.isFormVisible = false,
    this.isEditMode = false,
    this.classToEdit,
    this.formStatus = ClassManagementFormStatus.initial,
    this.formErrorMessage,
  });

  ClassManagementLoaded copyWith({
    List<ClassDetailViewEntity>? classes,
    bool? hasReachedMax,
    int? currentPage,
    Map<String, String>? currentSort,
    Map<String, dynamic>? currentFilter,
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
      currentPage: currentPage ?? this.currentPage,
      currentSort: currentSort ?? this.currentSort,
      currentFilter: currentFilter ?? this.currentFilter,
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
    currentPage,
    currentSort,
    currentFilter,
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
  final List<ClassDetailViewEntity> classes;
  final Map<String, String> currentSort;
  final Map<String, dynamic> currentFilter;

  const ClassManagementLoadingMore({
    required this.classes,
    required this.currentSort,
    required this.currentFilter,
  });

  @override
  List<Object?> get props => [classes, currentSort, currentFilter];
}

class ClassManagementFormLoading extends ClassManagementState {
  final List<ClassDetailViewEntity> classes;
  final Map<String, String> currentSort;
  final Map<String, dynamic> currentFilter;
  final bool isFormVisible;
  final bool isEditMode;
  final ClassEntity? classToEdit;

  const ClassManagementFormLoading({
    required this.classes,
    required this.currentSort,
    required this.currentFilter,
    required this.isFormVisible,
    required this.isEditMode,
    this.classToEdit,
  });

  @override
  List<Object?> get props => [
    classes,
    currentSort,
    currentFilter,
    isFormVisible,
    isEditMode,
    classToEdit,
  ];
}

enum ClassManagementFormStatus { initial, loading, success, error }
