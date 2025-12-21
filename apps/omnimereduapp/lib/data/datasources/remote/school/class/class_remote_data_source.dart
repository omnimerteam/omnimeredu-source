import '../../../../../core/add_jwt.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_response.dart';
import '../../../../../core/network/endpoints.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../models/class/add_student_to_class_model.dart';
import '../../../../models/class/class_model.dart';
import '../../../../models/class/transfer_class_for_student_model.dart';
import '../../../../models/view_model/class_detail_view_model.dart';
import '../../../../../domain/entities/class/class_search_entity.dart';
import '../../../../../domain/entities/query/default_query_entity.dart';
import '../../base_remote_data_source.dart';

class ClassRemoteDataSource extends BaseRemoteDataSource {
  ClassRemoteDataSource(ApiClient client, AppAuthProvider authProvider)
    : super(client, authProvider);

  // Tìm kiếm lớp học trong trường
  Future<List<ClassSearchEntity>> searchClassesInSchool(String schoolId) async {
    final res = await client.get<List<ClassSearchEntity>>(
      Endpoints.searchClassesInSchool,
      query: {"schoolId": schoolId},
      parser: (data) {
        if (data is List) {
          return data
              .map(
                (e) => ClassSearchEntity(
                  id: e["_id"].toString(),
                  name: e["name"].toString(),
                  code: e["code"].toString(),
                  schoolId: e["schoolId"].toString(),
                  gradeId: e["gradeId"].toString(),
                  gradeGroup: EducationGradesEnum.fromString(
                    e['gradeGroup'] as String?,
                  ),
                ),
              )
              .toList();
        }
        throw Exception("API không trả về danh sách lớp học hợp lệ");
      },
    );

    if (res.success) {
      final list = res.data ?? [];
      logger.i("List $list");
      return list;
    } else {
      throw Exception(res.message ?? "Không thể tìm lớp trong trường");
    }
  }

  Future<List<ClassModel>> getAllClasses(DefaultQueryEntity query) async {
    final headers = await authHeaders;
    final queryParams = query.toQueryBuilder().build();

    final res = await client.get<List<ClassModel>>(
      Endpoints.classes,
      headers: headers,
      query: queryParams,
      parser: (data) {
        if (data is List) {
          return data
              .map((e) => ClassModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        throw Exception("API không trả về danh sách lớp hợp lệ");
      },
    );

    if (res.success) {
      return res.data ?? [];
    } else {
      throw Exception(res.message ?? "Không thể lấy danh sách lớp");
    }
  }

  /// Lấy thông tin lớp học
  Future<ClassModel> getClassById(String id) async {
    final headers = await authHeaders;

    final res = await client.get<ClassModel>(
      Endpoints.classId(id),
      headers: headers,
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return ClassModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu lớp hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể lấy danh sách lớp");
    }
  }

  /// Lấy thông tin lớp học
  Future<ClassDetailViewModel> getClassDetailViewById(String id) async {
    final headers = await authHeaders;

    final res = await client.get<ClassDetailViewModel>(
      Endpoints.classDetailViewId(id),
      headers: headers,
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return ClassDetailViewModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu lớp hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể lấy danh sách lớp");
    }
  }

  /// Tạo lớp học mới
  Future<ClassModel> createClass(ClassModel createClassData) async {
    final headers = await authHeaders;

    final res = await client.post<ClassModel>(
      Endpoints.classes,
      headers: headers,
      data: createClassData.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return ClassModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu lớp hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể tạo mới lớp");
    }
  }

  /// Cập nhật thông tin lớp học
  Future<ClassModel> updateClass(ClassModel updateClassData) async {
    final id = updateClassData.id;
    if (id == null) {
      throw Exception("Lớp chưa được chọn");
    }

    final headers = await authHeaders;

    final res = await client.put<ClassModel>(
      Endpoints.classId(id),
      headers: headers,
      data: updateClassData.toJson(),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return ClassModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu lớp hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể cập nhật thông tin lớp");
    }
  }

  // Xóa lớp của schoolAdmin
  Future<void> deleteClass(String id) async {
    final headers = await authHeaders;

    final res = await client.delete<void>(
      Endpoints.classId(id),
      headers: headers,
    );

    if (res.success) {
      return;
    } else {
      throw Exception(res.message ?? "Không thể xóa lớp");
    }
  }

  Future<ApiResponse<AddStudentToClassModel?>> addStudentToClass(
    String classId,
    List<String> studentIds,
  ) async {
    if (studentIds.isEmpty) {
      throw Exception("Danh sách học sinh không được để trống");
    }

    final headers = await authHeaders;

    final res = await client.post<AddStudentToClassModel?>(
      Endpoints.addStudentToClass(classId),
      headers: headers,
      data: {"studentIds": studentIds},
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return AddStudentToClassModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    return res;
  }

  Future<ApiResponse<void>> removeStudentFromClass(
    String classId,
    List<String> studentIds,
  ) async {
    if (studentIds.isEmpty) {
      throw Exception("Danh sách học sinh không được để trống");
    }

    final headers = await authHeaders;

    final res = await client.post<void>(
      Endpoints.removeStudentFromClass(classId),
      headers: headers,
      data: {"studentIds": studentIds},
    );

    return res;
  }

  Future<ApiResponse<TransferClassForStudentModel?>> transferClass(
    String classId,
    String targetClassId,
    List<String> studentIds,
  ) async {
    if (studentIds.isEmpty) {
      throw Exception("Danh sách học sinh không được để trống");
    }

    final headers = await authHeaders;

    final res = await client.post<TransferClassForStudentModel?>(
      Endpoints.transferClass(classId),
      headers: headers,
      data: {"studentIds": studentIds, "targetClassId": targetClassId},
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return TransferClassForStudentModel.fromJson(data);
        }
        throw Exception("API không trả về dữ liệu hợp lệ");
      },
    );

    return res;
  }
}
