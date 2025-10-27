import 'package:flutter_ios_android_platforms/core/error/failures.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/user/student_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/models/user/student_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_selector_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource remote;

  StudentRepositoryImpl(this.remote);

  @override
  Future<List<StudentEntity>> getAllStudents(DefaultQueryEntity query) async {
    try {
      final models = await remote.getAllStudents(query);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw ServerFailure("Không thể lấy danh sách học sinh: $e");
    }
  }

  @override
  Future<StudentEntity> getStudentById(String id) async {
    try {
      final model = await remote.getStudentById(id);
      return model.toEntity();
    } catch (e) {
      throw ServerFailure("Không thể lấy thông tin học sinh: $e");
    }
  }

  @override
  Future<StudentEntity> createStudent(StudentEntity createStudentData) async {
    try {
      final model = StudentModel.fromEntity(createStudentData);
      final createdModel = await remote.createStudent(model);
      return createdModel.toEntity();
    } catch (e) {
      throw ServerFailure("Không thể tạo mới học sinh: $e");
    }
  }

  @override
  Future<ApiResponse<StudentEntity>> updateStudent(
    StudentEntity updateStudentData,
  ) async {
    try {
      final model = StudentModel.fromEntity(updateStudentData);
      final res = await remote.updateStudent(model);
      return ApiResponse<StudentEntity>(
        success: res.success,
        message: res.message,
        data: res.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure("Không thể cập nhật học sinh: $e");
    }
  }

  @override
  Future<void> deleteStudent(String id) async {
    try {
      await remote.deleteStudent(id);
    } catch (e) {
      throw ServerFailure("Xóa học sinh thất bại: $e");
    }
  }

  @override
  Future<ApiResponse<List<StudentSelectorEntity>?>> getStudentSelector(
    String? gradeId,
  ) async {
    try {
      final res = await remote.getStudentSelector(gradeId);
      return ApiResponse<List<StudentSelectorEntity>?>(
        success: res.success,
        message: res.message,
        data: res.data?.map((m) => m.toEntity()).toList(),
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
