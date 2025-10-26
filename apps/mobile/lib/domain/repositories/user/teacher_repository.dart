import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/teacher_entity.dart';

abstract class TeacherRepository {
  Future<ApiResponse<TeacherEntity?>> updateTeacher(
    TeacherEntity updateTeacherData,
  );
}
