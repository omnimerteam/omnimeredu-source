import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_entity.dart';

abstract class StudentRepository {
  Future<List<StudentEntity>> getAllStudents(DefaultQueryEntity query);

  Future<StudentEntity> createStudent(StudentEntity createStudentData);

  Future<StudentEntity> getStudentById(String id);

  Future<StudentEntity> updateStudent(StudentEntity updateStudentData);

  Future<void> deleteStudent(String id);
}
