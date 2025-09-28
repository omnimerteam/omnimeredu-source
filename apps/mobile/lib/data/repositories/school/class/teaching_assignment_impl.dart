import 'package:flutter_ios_android_platforms/core/error/failures.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/class/teaching_assignment_data_source.dart';
import 'package:flutter_ios_android_platforms/data/models/teaching_assignment/teaching_assignment_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/teaching_assignment/teaching_assignment_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/teaching_assignment_repository.dart';

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
  Future<ApiResponse<TeachingAssignmentEntity>> createTeachingAssignment(
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
  Future<ApiResponse<TeachingAssignmentEntity>> updateTeachingAssignment(
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
}
