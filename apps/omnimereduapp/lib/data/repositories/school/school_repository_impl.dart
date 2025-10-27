// data/repositories/school_repository_impl.dart
import '../../../core/constants/enum_constant.dart';
import '../../../core/error/failures.dart';
import '../../../core/utils/logger.dart';
import '../../datasources/remote/school/school_remote_data_source.dart';
import '../../models/school/school_model.dart';
import '../../../domain/entities/school/school_data_entity.dart';
import '../../../domain/entities/school/school_search_entity.dart';
import '../../../domain/repositories/school/school_repository.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final SchoolRemoteDataSource remote;

  SchoolRepositoryImpl(this.remote);

  @override
  Future<List<SchoolSearchEntity>> getSchoolsByLevel(
    EducationSystemLevelsEnum educationLevel,
  ) async {
    return await remote.searchSchoolsByLevel(educationLevel, null);
  }

  @override
  Future<List<SchoolSearchEntity>> searchSchoolsByLevel(
    EducationSystemLevelsEnum educationLevel,
    String? query,
  ) async {
    return await remote.searchSchoolsByLevel(educationLevel, query);
  }

  @override
  Future<SchoolDataEntity> createSchool(
    SchoolDataEntity createSchoolData,
  ) async {
    try {
      final model = SchoolModel.fromEntity(createSchoolData);
      final createSchool = await remote.createSchool(model);
      return createSchool.toEntity();
    } catch (e) {
      // có thể log stacktrace để debug
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<SchoolDataEntity> updateSchool(
    SchoolDataEntity updateSchoolData,
  ) async {
    try {
      final model = SchoolModel.fromEntity(updateSchoolData);
      final updatedModel = await remote.updateSchool(model);
      return updatedModel.toEntity();
    } catch (e) {
      // có thể log stacktrace để debug
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteSchool() async {
    try {
      await remote.deleteSchool(); // remote đã throw nếu thất bại
      // Không cần return gì, xóa thành công
    } catch (e, st) {
      // Có thể log stacktrace để debug
      throw ServerFailure("Xóa trường thất bại: $e\n$st");
    }
  }

  @override
  Future<SchoolDataEntity?> getSchoolDetailForSchoolAdmin() async {
    try {
      final model = await remote.getSchoolDetailForSchoolAdmin();
      return model?.toEntity(); // null → null
    } catch (e) {
      // Chỉ log, không ném lỗi nếu muốn bloc xử lý Empty
      logger.e("Lỗi khi lấy chi tiết trường: $e");
      return null;
    }
  }
}
