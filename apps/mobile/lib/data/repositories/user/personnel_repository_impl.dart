import 'package:flutter_ios_android_platforms/core/error/failures.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/user/personnel_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/personnel_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/personnel_repository.dart';

class PersonnelRepositoryImpl implements PersonnelRepository {
  final PersonnelRemoteDataSource remote;

  PersonnelRepositoryImpl(this.remote);

  @override
  Future<ApiResponse<List<PersonnelEntity>>> getAllPersonnelFromSchool(
    DefaultQueryEntity query,
  ) async {
    try {
      final res = await remote.getAllPersonnelFromSchool(query);
      return ApiResponse<List<PersonnelEntity>>(
        success: res.success,
        message: res.message,
        data: res.data?.map((m) => m.toEntity()).toList(),
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ApiResponse<bool>> updateVerified(
    String personnelId,
    bool isVerified,
  ) async {
    try {
      final res = await remote.updateVerified(personnelId, isVerified);
      return ApiResponse<bool>(
        success: res.success,
        message: res.message,
        data: res.data,
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ApiResponse<void>> dismissPersonnel(String personnelId) async {
    try {
      final res = await remote.dismissPersonnel(personnelId);
      return ApiResponse<void>(success: res.success, message: res.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
