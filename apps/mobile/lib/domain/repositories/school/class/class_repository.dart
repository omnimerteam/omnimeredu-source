import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/add_student_to_class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/class_search_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/class/transfer_class_for_student_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/view_model/class_detail_view_entity.dart';

abstract class ClassRepository {
  Future<List<ClassSearchEntity>> getClassesInSchool(String schoolId);

  Future<List<ClassEntity>> getAllClasses(DefaultQueryEntity query);

  Future<ClassEntity> createClass(ClassEntity createClassData);

  Future<ClassEntity> getClassById(String id);

  Future<ClassEntity> updateClass(ClassEntity updateClassData);

  Future<void> deleteClass(String id);

  Future<ClassDetailViewEntity> getClassDetailViewById(String id);

  Future<ApiResponse<AddStudentToClassEntity?>> addStudentToClass(
    String classId,
    List<String> studentIds,
  );

  Future<ApiResponse<void>> removeStudentFromClass(
    String classId,
    List<String> studentIds,
  );

  Future<ApiResponse<TransferClassForStudentEntity?>> transferClass(
    String classId,
    String targetClassId,
    List<String> studentIds,
  );
}
