import '../dashboard_data_base_entity.dart';
import '../../teaching_assignment/class_teacher_assign_entity.dart';

/// 🔹 Dashboard cho Teacher
class TeacherDashboardDataEntity extends DashboardDataBaseEntity {
  final List<ClassTeacherAssignEntity>? classAssignment;

  TeacherDashboardDataEntity({
    required this.classAssignment,
    required DateTime cachedAt,
  }) : super(cachedAt: cachedAt);

  /// Convert Entity -> Map (dùng để cache)
  @override
  Map<String, dynamic> toJson() => {
    'classAssignment': classAssignment?.map((e) => e.toJson()).toList(),
    'cachedAt': cachedAt.toIso8601String(),
  };

  /// Convert Map -> Entity (dùng khi load cache)
  factory TeacherDashboardDataEntity.fromJson(Map<String, dynamic> json) {
    return TeacherDashboardDataEntity(
      classAssignment: (json['classAssignment'] as List<dynamic>)
          .map((e) => ClassTeacherAssignEntity.fromJson(e))
          .toList(),
      cachedAt: DateTime.parse(json['cachedAt']),
    );
  }

  /// Copy với cachedAt mới (dùng trong cache)
  @override
  DashboardDataBaseEntity copyWith({
    required DateTime cachedAt,
    List<ClassTeacherAssignEntity>? classAssignment,
  }) {
    return TeacherDashboardDataEntity(
      classAssignment: classAssignment,
      cachedAt: cachedAt,
    );
  }
}
