import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../core/error/failures.dart';
import '../../../models/auth/role_model.dart';

abstract class RoleRemoteDataSource {
  Future<List<RoleModel>> getAllRoles();
  Future<List<RoleModel>> getRolesPersonnel();
}

class RoleRemoteDataSourceImpl implements RoleRemoteDataSource {
  final ApiClient client;

  RoleRemoteDataSourceImpl(this.client);

  @override
  Future<List<RoleModel>> getAllRoles() async {
    try {
      final response = await client.get<List>(
        Endpoints.user.roles,
        parser: (data) {
          if (data is List) {
            return data
                .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );

      if (response.success && response.data != null) {
        return response.data!.map((e) => e as RoleModel).toList();
      } else {
        throw ServerFailure(response.message);
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<RoleModel>> getRolesPersonnel() async {
    // Assuming same endpoint or specific one if available.
    // Reference used specific endpoint. Mobile Endpoints currently only has 'roles'.
    // We will use 'roles' for now.
    return getAllRoles();
  }
}
