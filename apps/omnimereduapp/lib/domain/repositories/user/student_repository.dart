import '../../../core/network/api_response.dart';
import '../../entities/query/default_query_entity.dart';
import '../../entities/user/student_entity.dart';
import '../../entities/user/student_selector_entity.dart';

abstract class StudentRepository {
  Future<List<StudentEntity>> getAllStudents(DefaultQueryEntity query);

  Future<StudentEntity> createStudent(StudentEntity createStudentData);

  Future<StudentEntity> getStudentById(String id);

  Future<ApiResponse<StudentEntity>> updateStudent(
    StudentEntity updateStudentData,
  );

  Future<void> deleteStudent(String id);

  Future<ApiResponse<List<StudentSelectorEntity>?>> getStudentSelector(
    String? gradeId,
  );
}
