import '../../../../core/add_jwt.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/logger.dart';
import '../../../models/auth/role_model.dart';
import '../../../../core/network/endpoints.dart';
import '../base_remote_data_source.dart';

class RoleRemoteDataSource extends BaseRemoteDataSource {
  RoleRemoteDataSource(ApiClient client, AppAuthProvider authProvider)
    : super(client, authProvider);

  Future<List<RoleModel>> getAllRoles() async {
    try {
      final headers = await authHeaders;

      final response = await client.get<List<RoleModel>>(
        Endpoints.roles,
        headers: headers,
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

  Future<List<RoleModel>> getRolesPersonnel() async {
    try {
      final headers = await authHeaders;

      final response = await client.get<List<RoleModel>>(
        Endpoints.rolesPersonnel,
        headers: headers,
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
