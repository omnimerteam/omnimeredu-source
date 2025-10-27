import '../../../core/network/api_response.dart';
import '../../entities/user/teacher_entity.dart';

abstract class TeacherRepository {
  Future<ApiResponse<TeacherEntity?>> updateTeacher(
    TeacherEntity updateTeacherData,
  );
}
