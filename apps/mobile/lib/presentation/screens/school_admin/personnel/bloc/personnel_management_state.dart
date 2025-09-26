import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/teaching_assignment/teaching_assignment_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/personnel_entity.dart';

/// 🔹 Trạng thái assignment khi thao tác
enum PersonnelAssignmentStatus { initial, loading, success, error }

/// 🔹 Base state
abstract class PersonnelManagementState {
  const PersonnelManagementState();
}

/// 🔹 State khởi tạo
class PersonnelManagementInitial extends PersonnelManagementState {
  const PersonnelManagementInitial();
}

/// 🔹 State loading danh sách chính
class PersonnelManagementLoading extends PersonnelManagementState {
  const PersonnelManagementLoading();
}

/// 🔹 State loading khi loadMore
class PersonnelManagementLoadingMore extends PersonnelManagementState {
  final List<PersonnelEntity> personnel; // List<PersonnelEntity>
  final DefaultQueryEntity currentQuery;

  const PersonnelManagementLoadingMore({
    required this.personnel,
    required this.currentQuery,
  });
}

/// 🔹 State đã load đầy đủ danh sách & các thông tin chi tiết
class PersonnelManagementLoaded extends PersonnelManagementState {
  final List<PersonnelEntity> personnel; // List<PersonnelEntity>
  final bool hasReachedMax;
  final DefaultQueryEntity currentQuery;
  final String? message;
  final bool lastActionSuccess;

  // 🔸 Chi tiết nhân sự
  final dynamic selectedPersonnelDetails; // PersonnelEntity?
  final bool isDetailsVisible;
  final bool isLoadingDetails;
  final String? detailsErrorMessage;

  // 🔸 Phân công
  final dynamic selectedPersonnelForAssignment; // PersonnelEntity?
  final bool isAssignmentDialogVisible;
  final PersonnelAssignmentStatus assignmentStatus;
  final String? assignmentErrorMessage;

  /// ✅ Assignment hiện tại của teacher (dùng trong dialog)
  final TeachingAssignmentEntity? currentTeachingAssignment;

  const PersonnelManagementLoaded({
    required this.personnel,
    required this.hasReachedMax,
    required this.currentQuery,
    this.message,
    required this.lastActionSuccess,
    this.selectedPersonnelDetails,
    this.isDetailsVisible = false,
    this.isLoadingDetails = false,
    this.detailsErrorMessage,
    this.selectedPersonnelForAssignment,
    this.isAssignmentDialogVisible = false,
    this.assignmentStatus = PersonnelAssignmentStatus.initial,
    this.assignmentErrorMessage,
    this.currentTeachingAssignment,
  });

  PersonnelManagementLoaded copyWith({
    List<PersonnelEntity>? personnel,
    bool? hasReachedMax,
    DefaultQueryEntity? currentQuery,
    String? message,
    bool? lastActionSuccess,

    // details
    dynamic selectedPersonnelDetails,
    bool? isDetailsVisible,
    bool? isLoadingDetails,
    String? detailsErrorMessage,

    // assignment
    dynamic selectedPersonnelForAssignment,
    bool? isAssignmentDialogVisible,
    PersonnelAssignmentStatus? assignmentStatus,
    String? assignmentErrorMessage,
    TeachingAssignmentEntity? currentTeachingAssignment,

    // clear flags
    bool clearDetailsErrorMessage = false,
    bool clearSelectedPersonnelDetails = false,
    bool clearSelectedPersonnelForAssignment = false,
    bool clearAssignmentErrorMessage = false,
    bool clearCurrentTeachingAssignment = false,
  }) {
    return PersonnelManagementLoaded(
      personnel: personnel ?? this.personnel,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentQuery: currentQuery ?? this.currentQuery,
      message: message ?? this.message,
      lastActionSuccess: lastActionSuccess ?? this.lastActionSuccess,

      // details
      selectedPersonnelDetails: clearSelectedPersonnelDetails
          ? null
          : selectedPersonnelDetails ?? this.selectedPersonnelDetails,
      isDetailsVisible: isDetailsVisible ?? this.isDetailsVisible,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      detailsErrorMessage: clearDetailsErrorMessage
          ? null
          : detailsErrorMessage ?? this.detailsErrorMessage,

      // assignment
      selectedPersonnelForAssignment: clearSelectedPersonnelForAssignment
          ? null
          : selectedPersonnelForAssignment ??
                this.selectedPersonnelForAssignment,
      isAssignmentDialogVisible:
          isAssignmentDialogVisible ?? this.isAssignmentDialogVisible,
      assignmentStatus: assignmentStatus ?? this.assignmentStatus,
      assignmentErrorMessage: clearAssignmentErrorMessage
          ? null
          : assignmentErrorMessage ?? this.assignmentErrorMessage,

      // current assignment
      currentTeachingAssignment: clearCurrentTeachingAssignment
          ? null
          : currentTeachingAssignment ?? this.currentTeachingAssignment,
    );
  }
}

/// 🔹 State lỗi
class PersonnelManagementError extends PersonnelManagementState {
  final String message;
  const PersonnelManagementError(this.message);
}
