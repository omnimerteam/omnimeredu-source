import '../../../../core/api/api_response.dart';
import '../../../../core/constants/enum_constant.dart';
import '../../../../domain/entities/user/school_admin_entity.dart';
import '../../../../domain/repositories/user/school_admin_repository.dart';
import '../../datasources/remote/user/school_admin_remote_data_source.dart';
import '../../models/user/school_admin_model.dart';

class SchoolAdminRepositoryImpl implements SchoolAdminRepository {
  final SchoolAdminRemoteDataSource remoteDataSource;

  SchoolAdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResponse<SchoolAdminPositionEnum>> updatePositionSchoolAdmin(
    String schoolAdminId,
    SchoolAdminPositionEnum position,
  ) async {
    return await remoteDataSource.updatePositionSchoolAdmin(
      schoolAdminId,
      position,
    );
  }

  @override
  Future<ApiResponse<SchoolAdminEntity?>> updateSchoolAdmin(
    SchoolAdminEntity updateSchoolAdminData,
  ) async {
    // Convert Entity to Model
    // Assuming we can create Model from Entity or have a mapper.
    // Since SchoolAdminModel extends SchoolAdminEntity (via BaseUserModel/Entity hierarchy mismatch? No, Model extends BaseUserModel, Entity extends BaseUserEntity)
    // We need to construct Model manually.
    
    final model = SchoolAdminModel(
      id: updateSchoolAdminData.id,
      fullName: updateSchoolAdminData.fullName,
      roleId: updateSchoolAdminData.roleId,
      email: updateSchoolAdminData.email,
      gender: updateSchoolAdminData.gender,
      birthday: updateSchoolAdminData.birthday,
      phone: updateSchoolAdminData.phone,
      address: updateSchoolAdminData.address,
      isVerified: updateSchoolAdminData.isVerified,
      schoolId: updateSchoolAdminData.schoolId,
      avatarUrl: updateSchoolAdminData.avatarUrl,
      createdAt: updateSchoolAdminData.createdAt,
      updatedAt: updateSchoolAdminData.updatedAt,
      position: updateSchoolAdminData.position,
    );

    final result = await remoteDataSource.updateSchoolAdmin(model);
    
    return ApiResponse<SchoolAdminEntity?>(
      success: result.success,
      message: result.message,
      data: result.data?.toEntity(),
    );
  }
}
