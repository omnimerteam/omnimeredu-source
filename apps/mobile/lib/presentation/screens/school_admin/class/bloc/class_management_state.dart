// class_management_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/core/app_constants.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_detail_view_entity.dart';

enum ClassManagementStatus {
  initial,
  loading,
  loaded,
  error,
  formLoading,
  formSuccess,
  formError,
}

class ClassManagementState extends Equatable {
  final ClassManagementStatus status;
  final List<ClassDetailViewEntity> classes;
  final int currentPage;
  final bool hasMorePages;
  final String sortString; // Changed from currentSort + sortDirection
  final String? errorMessage;

  // Form related
  final bool isFormVisible;
  final bool isEditMode;
  final ClassEntity? classToEdit;
  final ClassManagementStatus formStatus;
  final String? formErrorMessage;

  const ClassManagementState({
    this.status = ClassManagementStatus.initial,
    this.classes = const [],
    this.currentPage = AppConstants.defaultPage,
    this.hasMorePages = true,
    this.sortString = AppConstants.nameSort,
    this.errorMessage,
    this.isFormVisible = false,
    this.isEditMode = false,
    this.classToEdit,
    this.formStatus = ClassManagementStatus.initial,
    this.formErrorMessage,
  });

  // Helper methods to parse sortString
  String get currentSortField {
    if (sortString.contains(':')) {
      return sortString.split(':')[0];
    }
    return sortString;
  }

  String get currentSortDirection {
    if (sortString.contains(':')) {
      return sortString.split(':')[1];
    }
    return 'asc'; // default
  }

  bool get isAscending => currentSortDirection == 'asc';
  bool get isDescending => currentSortDirection == 'desc';

  ClassManagementState copyWith({
    ClassManagementStatus? status,
    List<ClassDetailViewEntity>? classes,
    int? currentPage,
    bool? hasMorePages,
    String? sortString,
    String? errorMessage,
    bool? isFormVisible,
    bool? isEditMode,
    ClassEntity? classToEdit,
    ClassManagementStatus? formStatus,
    String? formErrorMessage,
  }) {
    return ClassManagementState(
      status: status ?? this.status,
      classes: classes ?? this.classes,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      sortString: sortString ?? this.sortString,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormVisible: isFormVisible ?? this.isFormVisible,
      isEditMode: isEditMode ?? this.isEditMode,
      classToEdit: classToEdit ?? this.classToEdit,
      formStatus: formStatus ?? this.formStatus,
      formErrorMessage: formErrorMessage ?? this.formErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    classes,
    currentPage,
    hasMorePages,
    sortString,
    errorMessage,
    isFormVisible,
    isEditMode,
    classToEdit,
    formStatus,
    formErrorMessage,
  ];
}
