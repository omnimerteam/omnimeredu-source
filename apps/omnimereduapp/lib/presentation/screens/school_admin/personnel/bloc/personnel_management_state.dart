import '../../../../../domain/entities/query/default_query_entity.dart';
import '../../../../../domain/entities/teaching_assignment/teaching_assignment_entity.dart';
import '../../../../../domain/entities/user/personnel_entity.dart';

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
  final List<PersonnelEntity> personnel;
  final DefaultQueryEntity currentQuery;

  const PersonnelManagementLoadingMore({
    required this.personnel,
    required this.currentQuery,
  });
}

/// Sentinel marker để phân biệt "không truyền gì" với "truyền null"
const _sentinel = Object();

/// 🔹 State đã load đầy đủ danh sách & các thông tin chi tiết
class PersonnelManagementLoaded extends PersonnelManagementState {
  final List<PersonnelEntity> personnel;
  final bool hasReachedMax;
  final DefaultQueryEntity currentQuery;
  final String? message;
  final bool lastActionSuccess;

  // 🔸 Chi tiết nhân sự
  final PersonnelEntity? selectedPersonnelDetails;
  final bool isDetailsVisible;
  final bool isLoadingDetails;
  final String? detailsErrorMessage;

  // 🔸 Phân công
  final PersonnelEntity? selectedPersonnelForAssignment;
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
    Object? message = _sentinel,
    bool? lastActionSuccess,

    // details
    Object? selectedPersonnelDetails = _sentinel,
    bool? isDetailsVisible,
    bool? isLoadingDetails,
    Object? detailsErrorMessage = _sentinel,

    // assignment
    Object? selectedPersonnelForAssignment = _sentinel,
    bool? isAssignmentDialogVisible,
    PersonnelAssignmentStatus? assignmentStatus,
    Object? assignmentErrorMessage = _sentinel,
    Object? currentTeachingAssignment = _sentinel,
  }) {
    return PersonnelManagementLoaded(
      personnel: personnel ?? this.personnel,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentQuery: currentQuery ?? this.currentQuery,
      message: message == _sentinel ? this.message : message as String?,
      lastActionSuccess: lastActionSuccess ?? this.lastActionSuccess,

      // details
      selectedPersonnelDetails: selectedPersonnelDetails == _sentinel
          ? this.selectedPersonnelDetails
          : selectedPersonnelDetails as PersonnelEntity?,
      isDetailsVisible: isDetailsVisible ?? this.isDetailsVisible,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      detailsErrorMessage: detailsErrorMessage == _sentinel
          ? this.detailsErrorMessage
          : detailsErrorMessage as String?,

      // assignment
      selectedPersonnelForAssignment:
          selectedPersonnelForAssignment == _sentinel
          ? this.selectedPersonnelForAssignment
          : selectedPersonnelForAssignment as PersonnelEntity?,
      isAssignmentDialogVisible:
          isAssignmentDialogVisible ?? this.isAssignmentDialogVisible,
      assignmentStatus: assignmentStatus ?? this.assignmentStatus,
      assignmentErrorMessage: assignmentErrorMessage == _sentinel
          ? this.assignmentErrorMessage
          : assignmentErrorMessage as String?,
      currentTeachingAssignment: currentTeachingAssignment == _sentinel
          ? this.currentTeachingAssignment
          : currentTeachingAssignment as TeachingAssignmentEntity?,
    );
  }
}

/// 🔹 State lỗi
class PersonnelManagementError extends PersonnelManagementState {
  final String message;
  const PersonnelManagementError(this.message);
}
