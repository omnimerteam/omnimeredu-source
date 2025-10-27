import 'package:equatable/equatable.dart';

abstract class ClassMemberEvent extends Equatable {
  const ClassMemberEvent();

  @override
  List<Object?> get props => [];
}

/// Event để load danh sách học sinh
class LoadStudents extends ClassMemberEvent {
  final String? gradeId;
  final ClassMemberMode mode;
  final String? currentClassId; // Dùng cho mode Remove và Transfer

  const LoadStudents({this.gradeId, required this.mode, this.currentClassId});

  @override
  List<Object?> get props => [gradeId, mode, currentClassId];
}

/// Event khi chọn/bỏ chọn học sinh
class ToggleStudentSelection extends ClassMemberEvent {
  final String studentId;

  const ToggleStudentSelection(this.studentId);

  @override
  List<Object?> get props => [studentId];
}

/// Event khi chọn/bỏ chọn tất cả
class ToggleSelectAll extends ClassMemberEvent {
  const ToggleSelectAll();
}

/// Event khi thay đổi chế độ (Thêm/Rút/Chuyển)
class ChangeMemberMode extends ClassMemberEvent {
  final ClassMemberMode mode;

  const ChangeMemberMode(this.mode);

  @override
  List<Object?> get props => [mode];
}

/// Event khi chọn lớp
class SelectClass extends ClassMemberEvent {
  final String? classId;

  const SelectClass(this.classId);

  @override
  List<Object?> get props => [classId];
}

/// Event khi chọn lớp đích (cho Transfer)
class SelectTargetClass extends ClassMemberEvent {
  final String? targetClassId;

  const SelectTargetClass(this.targetClassId);

  @override
  List<Object?> get props => [targetClassId];
}

/// Event khi thay đổi query search
class ChangeSearchQuery extends ClassMemberEvent {
  final String query;

  const ChangeSearchQuery(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event submit (Thêm/Rút/Chuyển học sinh)
class SubmitClassMember extends ClassMemberEvent {
  const SubmitClassMember();
}

/// Event reset state
class ResetClassMember extends ClassMemberEvent {
  const ResetClassMember();
}

/// Enum cho các chế độ
enum ClassMemberMode {
  add, // Nhập lớp
  remove, // Rút lớp
  transfer, // Chuyển lớp
}
