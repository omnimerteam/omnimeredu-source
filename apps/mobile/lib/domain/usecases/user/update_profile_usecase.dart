import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/school_admin_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/staff_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/teacher_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/school_admin_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/staff_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/student_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/teacher_repository.dart';

/// Use case cập nhật thông tin người dùng (avatar hoặc bất kỳ dữ liệu nào khác)
/// tùy theo vai trò hiện tại.
///
/// Vai trò được truyền vào thông qua [UserRoleEnum].
class UpdateProfileUseCase {
  final StudentRepository studentRepository;
  final TeacherRepository teacherRepository;
  final SchoolAdminRepository schoolAdminRepository;
  final StaffRepository staffRepository;

  UpdateProfileUseCase(
    this.schoolAdminRepository,
    this.studentRepository,
    this.teacherRepository,
    this.staffRepository,
  );

  /// Hàm chính gọi repository phù hợp dựa vào [roleName].
  ///
  /// - Trả về `ApiResponse` chứa entity đã được cập nhật.
  /// - Ném lỗi nếu vai trò không hợp lệ hoặc dữ liệu không khớp entity.
  Future<ApiResponse<dynamic>> call({
    required roleName,
    required dynamic userData,
  }) async {
    switch (roleName) {
      case "Student":
        if (userData is! StudentEntity) {
          throw ArgumentError('Dữ liệu không hợp lệ cho học sinh');
        }
        return await studentRepository.updateStudent(userData);

      case "Teacher":
        if (userData is! TeacherEntity) {
          throw ArgumentError('Dữ liệu không hợp lệ cho giáo viên');
        }
        return await teacherRepository.updateTeacher(userData);

      case "SchoolAdmin":
        if (userData is! SchoolAdminEntity) {
          throw ArgumentError('Dữ liệu không hợp lệ cho quản trị viên trường');
        }
        return await schoolAdminRepository.updateSchoolAdmin(userData);

      case "Staff":
        if (userData is! StaffEntity) {
          throw ArgumentError('Dữ liệu không hợp lệ cho nhân viên');
        }
        return await staffRepository.updateStaff(userData);

      default:
        throw UnsupportedError('Vai trò không được hỗ trợ: $roleName');
    }
  }
}
