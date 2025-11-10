import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response.dart';
import '../../../datasources/remote/school/class/class_remote_data_source.dart';
import '../../../models/class/class_model.dart';
import '../../../../domain/entities/class/add_student_to_class_entity.dart';
import '../../../../domain/entities/class/class_entity.dart';
import '../../../../domain/entities/class/class_search_entity.dart';
import '../../../../domain/entities/class/transfer_class_for_student_entity.dart';
import '../../../../domain/entities/query/default_query_entity.dart';
import '../../../../domain/entities/view_model/class_detail_view_entity.dart';
import '../../../../domain/repositories/school/class/class_repository.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassRemoteDataSource remote;

  ClassRepositoryImpl(this.remote);
  @override
  Future<List<ClassSearchEntity>> getClassesInSchool(String schoolId) async {
    return await remote.searchClassesInSchool(schoolId);
  }

  @override
  Future<List<ClassEntity>> getAllClasses(DefaultQueryEntity query) async {
    try {
      final models = await remote.getAllClasses(query);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw ServerFailure("Không thể lấy danh sách lớp");
    }
  }

  @override
  Future<ClassEntity> getClassById(String id) async {
    try {
      final model = await remote.getClassById(id);

      return model.toEntity();
    } catch (e) {
      throw ServerFailure("Không thể lấy danh sách lớp: $e");
    }
  }

  @override
  Future<ClassEntity> createClass(ClassEntity createClassData) async {
    try {
      final model = ClassModel.fromEntity(createClassData);
      final creatModel = await remote.createClass(model);
      return creatModel.toEntity();
    } catch (e) {
      // có thể log stacktrace để debug
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ClassEntity> updateClass(ClassEntity updateClassData) async {
    try {
      final model = ClassModel.fromEntity(updateClassData);
      final updatedModel = await remote.updateClass(model);
      return updatedModel.toEntity();
    } catch (e) {
      // có thể log stacktrace để debug
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteClass(String id) async {
    try {
      await remote.deleteClass(id);
    } catch (e, st) {
      // Có thể log stacktrace để debug
      throw ServerFailure("Xóa trường thất bại: $e\n$st");
    }
  }

  @override
  Future<ClassDetailViewEntity> getClassDetailViewById(String id) async {
    try {
      final model = await remote.getClassDetailViewById(id);

      return model.toEntity();
    } catch (e) {
      throw ServerFailure("Không thể lấy danh sách lớp: $e");
    }
  }

  @override
  Future<ApiResponse<AddStudentToClassEntity?>> addStudentToClass(
    String classId,
    List<String> studentIds,
  ) async {
    try {
      final res = await remote.addStudentToClass(classId, studentIds);
      return ApiResponse<AddStudentToClassEntity?>(
        success: res.success,
        message: res.message,
        data: res.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ApiResponse<void>> removeStudentFromClass(
    String classId,
    List<String> studentIds,
  ) async {
    try {
      final res = await remote.removeStudentFromClass(classId, studentIds);
      return ApiResponse<AddStudentToClassEntity?>(
        success: res.success,
        message: res.message,
        data: null,
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ApiResponse<TransferClassForStudentEntity?>> transferClass(
    String classId,
    String targetClassId,
    List<String> studentIds,
  ) async {
    try {
      final res = await remote.transferClass(
        classId,
        targetClassId,
        studentIds,
      );
      return ApiResponse<TransferClassForStudentEntity?>(
        success: res.success,
        message: res.message,
        data: res.data?.toEntity(),
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
