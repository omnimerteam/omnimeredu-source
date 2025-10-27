import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/query/default_query_entity.dart';
import '../../../../../domain/entities/user/personnel_entity.dart';

/// Event cha
abstract class PersonnelManagementEvent {}

/// Load danh sách nhân sự
class LoadPersonnelEvent extends PersonnelManagementEvent {
  final DefaultQueryEntity? query;
  LoadPersonnelEvent({this.query});
}

/// Refresh lại danh sách
class RefreshPersonnelEvent extends PersonnelManagementEvent {}

/// Load thêm (phân trang)
class LoadMorePersonnelEvent extends PersonnelManagementEvent {}

/// Lọc dữ liệu
class FilterPersonnelEvent extends PersonnelManagementEvent {
  final Map<String, dynamic> filter;
  FilterPersonnelEvent(this.filter);
}

/// Sắp xếp dữ liệu
class SortPersonnelEvent extends PersonnelManagementEvent {
  final List<Map<String, String>> sort;
  SortPersonnelEvent(this.sort);
}

/// Tìm kiếm nhân sự
class SearchPersonnelEvent extends PersonnelManagementEvent {
  final String search;
  SearchPersonnelEvent(this.search);
}

/// Lấy chi tiết theo ID
class LoadPersonnelByIdEvent extends PersonnelManagementEvent {
  final String personnelId;
  LoadPersonnelByIdEvent(this.personnelId);
}

/// Show chi tiết một nhân sự
class ShowPersonnelDetailsEvent extends PersonnelManagementEvent {
  final dynamic personnel; // bạn có thể thay bằng PersonnelEntity
  ShowPersonnelDetailsEvent(this.personnel);
}

/// Ẩn chi tiết
class HidePersonnelDetailsEvent extends PersonnelManagementEvent {}

/// Hiện dialog phân công
class ShowAssignmentDialogEvent extends PersonnelManagementEvent {
  final dynamic personnel; // PersonnelEntity
  ShowAssignmentDialogEvent(this.personnel);
}

/// Ẩn dialog phân công
class HideAssignmentDialogEvent extends PersonnelManagementEvent {}

class CreateTeachingAssignmentEvent extends PersonnelManagementEvent {
  final dynamic assignment;
  CreateTeachingAssignmentEvent(this.assignment);
}

class UpdateTeachingAssignmentEvent extends PersonnelManagementEvent {
  final dynamic assignment;
  UpdateTeachingAssignmentEvent(this.assignment);
}

class DeleteTeachingAssignmentEvent extends PersonnelManagementEvent {
  final String assignmentId;
  DeleteTeachingAssignmentEvent(this.assignmentId);
}

/// Event mới - Tìm kiếm phân công theo teacher, class và school
class GetTeachingAssignmentByTeacherClassAndSchoolEvent
    extends PersonnelManagementEvent {
  final String teacherId;
  final String classId;
  final String schoolId;

  GetTeachingAssignmentByTeacherClassAndSchoolEvent({
    required this.teacherId,
    required this.classId,
    required this.schoolId,
  });
}

/// Đình chỉ nhân sự
class UpdatePersonnelStatusEvent extends PersonnelManagementEvent {
  final String personnelId;
  final bool isVerified; // true = khôi phục, false = đình chỉ
  UpdatePersonnelStatusEvent({
    required this.personnelId,
    required this.isVerified,
  });
}

class DismissPersonnelEvent extends PersonnelManagementEvent {
  final PersonnelEntity personnel;
  DismissPersonnelEvent(this.personnel);
}

class UpdateSchoolAdminPositionEvent extends PersonnelManagementEvent {
  final String personnelId;
  final SchoolAdminPositionEnum position;

  UpdateSchoolAdminPositionEvent({
    required this.personnelId,
    required this.position,
  });
}
