import '../../core/api/api_response.dart';
import '../../core/error/failures.dart';
import '../../core/utils/either.dart';
import '../../core/constants/enum_constant.dart';
import '../../domain/entities/auth/auth_user_entity.dart';
import '../../domain/entities/auth/login_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthUserEntity>> login(LoginEntity params) async {
    try {
      // TODO: Remove mock data implementation when backend is ready
      // For now, return mock data based on email domain
      if (_isMockMode) {
        return _getMockUser(params.email);
      }

      final model = await remoteDataSource.login(params);
      return Right(model.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  // TODO: Set this to false when backend is ready
  bool get _isMockMode => true;

  Either<Failure, AuthUserEntity> _getMockUser(String email) {
    // Extract domain from email to determine role
    final domain = email.split('@').last.toLowerCase();

    // Mock user data based on domain
    if (domain.contains('teacher') || domain.contains('edu')) {
      // Teacher role
      return Right(
        AuthUserEntity(
          id: 'teacher_001',
          fullName: 'Nguyễn Văn Giáo',
          roleName: 'teacher',
          isVerified: true,
          schoolId: 'school_001',
          schoolName: 'Trường THPT ABC',
          schoolLevel: EducationSystemLevelsEnum.HighSchool,
          avatarUrl: 'https://via.placeholder.com/150',
          qualification: TeacherQualificationEnum.DaiHoc,
          classId: 'class_001',
          className: '12A1',
          educationLevel: EducationSystemLevelsEnum.HighSchool,
          gradeGroup: EducationGradesEnum.HighSchool_12,
        ),
      );
    } else if (domain.contains('admin') || domain.contains('school')) {
      // School Admin role
      return Right(
        AuthUserEntity(
          id: 'admin_001',
          fullName: 'Trần Thị Hiệu trưởng',
          roleName: 'schooladmin',
          isVerified: true,
          schoolId: 'school_001',
          schoolName: 'Trường THPT ABC',
          schoolLevel: EducationSystemLevelsEnum.HighSchool,
          avatarUrl: 'https://via.placeholder.com/150',
          position: SchoolAdminPositionEnum.HieuTruong,
        ),
      );
    } else {
      // Student role (default)
      return Right(
        AuthUserEntity(
          id: 'student_001',
          fullName: 'Lê Văn Học sinh',
          roleName: 'student',
          isVerified: false,
          schoolId: 'school_001',
          schoolName: 'Trường THPT ABC',
          schoolLevel: EducationSystemLevelsEnum.HighSchool,
          avatarUrl: 'https://via.placeholder.com/150',
          classId: 'class_001',
          className: '12A1',
          educationLevel: EducationSystemLevelsEnum.HighSchool,
          gradeGroup: EducationGradesEnum.HighSchool_12,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity?>> getCurrentUser() async {
    try {
      // TODO: Remove mock data implementation when backend is ready
      if (_isMockMode) {
        // For now, return null (user not logged in)
        // In a real implementation, this would check stored tokens
        return const Right(null);
      }

      final model = await remoteDataSource.getCurrentUser();
      return Right(model?.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<ApiResponse<void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    return await remoteDataSource.changePassword(oldPassword, newPassword);
  }
}
