import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_selector_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/bloc/class_member_event.dart';

abstract class ClassMemberState extends Equatable {
  const ClassMemberState();

  @override
  List<Object?> get props => [];
}

class ClassMemberInitial extends ClassMemberState {
  const ClassMemberInitial();
}

class ClassMemberLoading extends ClassMemberState {
  const ClassMemberLoading();
}

class ClassMemberLoaded extends ClassMemberState {
  final List<StudentSelectorEntity> allStudents;
  final List<StudentSelectorEntity> filteredStudents;
  final Set<String> selectedStudentIds;
  final ClassMemberMode mode;
  final String? selectedClassId;
  final String? targetClassId; // Cho chế độ chuyển lớp
  final String searchQuery;
  final bool isSubmitting;

  const ClassMemberLoaded({
    required this.allStudents,
    required this.filteredStudents,
    required this.selectedStudentIds,
    required this.mode,
    this.selectedClassId,
    this.targetClassId,
    this.searchQuery = '',
    this.isSubmitting = false,
  });

  @override
  List<Object?> get props => [
    allStudents,
    filteredStudents,
    selectedStudentIds,
    mode,
    selectedClassId,
    targetClassId,
    searchQuery,
    isSubmitting,
  ];

  ClassMemberLoaded copyWith({
    List<StudentSelectorEntity>? allStudents,
    List<StudentSelectorEntity>? filteredStudents,
    Set<String>? selectedStudentIds,
    ClassMemberMode? mode,
    String? selectedClassId,
    String? targetClassId,
    String? searchQuery,
    bool? isSubmitting,
  }) {
    return ClassMemberLoaded(
      allStudents: allStudents ?? this.allStudents,
      filteredStudents: filteredStudents ?? this.filteredStudents,
      selectedStudentIds: selectedStudentIds ?? this.selectedStudentIds,
      mode: mode ?? this.mode,
      selectedClassId: selectedClassId ?? this.selectedClassId,
      targetClassId: targetClassId ?? this.targetClassId,
      searchQuery: searchQuery ?? this.searchQuery,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  /// Helper để check xem có thể submit không
  bool get canSubmit {
    if (isSubmitting || selectedStudentIds.isEmpty) return false;

    switch (mode) {
      case ClassMemberMode.add:
        return selectedClassId != null;
      case ClassMemberMode.remove:
        return selectedClassId != null;
      case ClassMemberMode.transfer:
        return selectedClassId != null && targetClassId != null;
    }
  }
}

class ClassMemberSuccess extends ClassMemberState {
  final String message;
  final int successCount;
  final int failedCount;

  const ClassMemberSuccess({
    required this.message,
    required this.successCount,
    required this.failedCount,
  });

  @override
  List<Object?> get props => [message, successCount, failedCount];
}

class ClassMemberError extends ClassMemberState {
  final String message;

  const ClassMemberError(this.message);

  @override
  List<Object?> get props => [message];
}
