import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import '../../../models/role_model.dart';
import '../../../../core/network/endpoints.dart';

class RoleRemoteDataSource {
  final ApiClient client;

  RoleRemoteDataSource(this.client);

  Future<List<RoleModel>> fetchRoles() async {
    try {
      final response = await client.get<List<RoleModel>>(
        Endpoints.roles,
        parser: (data) {
          if (data is List) {
            return data
                .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          throw Exception("API trả về không phải List");
        },
      );

      if (response.success) {
        return response.data ?? [];
      } else {
        throw Exception(response.message ?? "Không thể lấy roles");
      }
    } catch (e) {
      logger.e("❌ Exception khi fetch roles: $e");
      throw Exception("Lỗi khi fetch roles: $e");
    }
  }
}
