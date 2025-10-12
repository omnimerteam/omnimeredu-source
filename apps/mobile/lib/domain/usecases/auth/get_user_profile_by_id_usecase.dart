import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/base_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/auth/auth_repository.dart';

class GetUserProfileByIdUseCase {
  final AuthRepository repo;
  GetUserProfileByIdUseCase(this.repo);
  Future<ApiResponse<BaseUserEntity>> getUserProfileById(String userId) async {
    return await repo.getUserProfileById(userId);
  }
}
