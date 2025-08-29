import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import '../../models/role_model.dart';
import '../../../core/network/endpoints.dart';

class RoleRemoteDataSource {
  final ApiClient client;

  RoleRemoteDataSource(this.client);

  Future<List<RoleModel>> fetchRoles() async {
    final response = await client.get(Endpoints.roles);

    final List data = response.data as List;
    return data.map((json) => RoleModel.fromJson(json)).toList();
  }
}
