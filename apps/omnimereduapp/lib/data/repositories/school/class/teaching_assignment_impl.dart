import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response.dart';
import '../../../datasources/remote/school/class/teaching_assignment_data_source.dart';
import '../../../models/teaching_assignment/teaching_assignment_model.dart';
import '../../../../domain/entities/class/class_search_entity.dart';
import '../../../../domain/entities/teaching_assignment/class_teacher_assign_entity.dart';
import '../../../../domain/entities/teaching_assignment/teaching_assignment_entity.dart';
import '../../../../domain/repositories/school/class/teaching_assignment_repository.dart';

class TeachingAssignmentRepositoryImpl implements TeachingAssignmentRepository {
  final TeachingAssignmentRemoteDataSource remote;

  TeachingAssignmentRepositoryImpl(this.remote);

  /// 🔹 Lấy danh sách teaching assignment theo teacherId + schoolId
  @override
  Future<ApiResponse<TeachingAssignmentEntity?>>
  getTeachingAssignmentByTeacherClassAndSchool(
    String teacherId,
    String schoolId,
    String classId,
  ) async {
    try {
      final res = await remote.getTeachingAssignmentByTeacherClassAndSchool(
        teacherId,
        schoolId,
        classId,
      );
      return ApiResponse<TeachingAssignmentEntity>(
        success: res.success,
        message: res.message,
        data: res.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  /// 🔹 Tạo teaching assignment
  @override
  Future<ApiResponse<TeachingAssignmentEntity?>> createTeachingAssignment(
    TeachingAssignmentEntity assignment,
  ) async {
    try {
      final res = await remote.createTeachingAssignment(
        TeachingAssignmentModel.fromEntity(assignment),
      );
      return ApiResponse<TeachingAssignmentEntity>(
        success: res.success,
        message: res.message,
        data: res.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  /// 🔹 Cập nhật teaching assignment
  @override
  Future<ApiResponse<TeachingAssignmentEntity?>> updateTeachingAssignment(
    TeachingAssignmentEntity assignment,
  ) async {
    try {
      final res = await remote.updateTeachingAssignment(
        TeachingAssignmentModel.fromEntity(assignment),
      );
      return ApiResponse<TeachingAssignmentEntity>(
        success: res.success,
        message: res.message,
        data: res.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  /// 🔹 Xóa teaching assignment
  @override
  Future<ApiResponse<void>> deleteTeachingAssignment(String id) async {
    try {
      final res = await remote.delete(id);
      return ApiResponse<void>(
        success: res.success,
        message: res.message,
        data: null,
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ApiResponse<List<ClassTeacherAssignEntity>?>>
  getClassTeacherAssignments(String teacherId, String schoolId) async {
    try {
      final res = await remote.getClassTeacherAssignments(teacherId, schoolId);
      return ApiResponse<List<ClassTeacherAssignEntity>?>(
        success: res.success,
        message: res.message,
        data: res.data?.map((e) => e.toEntity()).toList(),
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ApiResponse<List<ClassSearchEntity>?>>
  getClassesTeacherAssignByTeacherId(String teacherId) async {
    try {
      final res = await remote.getClassesTeacherAssignByTeacherId(teacherId);
      return ApiResponse<List<ClassSearchEntity>?>(
        success: res.success,
        message: res.message,
        data: res.data?.map((e) => e.toEntity()).toList(),
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
