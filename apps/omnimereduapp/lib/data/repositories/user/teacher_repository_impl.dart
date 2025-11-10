import '../../../core/error/failures.dart';
import '../../../core/network/api_response.dart';
import '../../datasources/remote/user/teacher_remote_data_source.dart';
import '../../models/user/teacher_model.dart';
import '../../../domain/entities/user/teacher_entity.dart';
import '../../../domain/repositories/user/teacher_repository.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final TeacherRemoteDataSource remote;

  TeacherRepositoryImpl(this.remote);

  @override
  Future<ApiResponse<TeacherEntity?>> updateTeacher(
    TeacherEntity updateTeacherData,
  ) async {
    try {
      final model = TeacherModel.fromEntity(updateTeacherData);
      final res = await remote.updateTeacher(model);

      // ✅ Trả về ApiResponse cùng cấu trúc, convert sang Entity
      return ApiResponse<TeacherEntity?>(
        success: res.success,
        message: res.message,
        data: res.data?.toEntity(),
      );
    } on ServerFailure catch (e) {
      // ✅ Nếu lỗi từ tầng dưới đã được wrap sẵn
      return ApiResponse<TeacherEntity?>(
        success: false,
        message: e.message,
        data: null,
      );
    } catch (e) {
      // ✅ Bắt mọi lỗi runtime khác, tránh throw ra ngoài không kiểm soát
      return ApiResponse<TeacherEntity?>(
        success: false,
        message: "Không thể cập nhật giáo viên: ${e.toString()}",
        data: null,
      );
    }
  }
}
