import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/teaching_assignment/class_teacher_assign_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/teaching_assignment/teaching_assignment_entity.dart';

abstract class TeachingAssignmentRepository {
  Future<ApiResponse<TeachingAssignmentEntity?>>
  getTeachingAssignmentByTeacherClassAndSchool(
    String teacherId,
    String schoolId,
    String classId,
  );

  Future<ApiResponse<TeachingAssignmentEntity?>> createTeachingAssignment(
    TeachingAssignmentEntity data,
  );

  Future<ApiResponse<TeachingAssignmentEntity?>> updateTeachingAssignment(
    TeachingAssignmentEntity data,
  );

  Future<ApiResponse<void>> deleteTeachingAssignment(String id);

  Future<ApiResponse<List<ClassTeacherAssignEntity>?>>
  getClassTeacherAssignments(String teacherId, String schoolId);

  Future<ApiResponse<List<ClassSearchEntity>?>>
  getClassesTeacherAssignByTeacherId(String teacherId);
}
