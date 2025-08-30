import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import '../../models/role_model.dart';
import '../../../core/network/endpoints.dart';

class RoleRemoteDataSource {
  final ApiClient client;

  RoleRemoteDataSource(this.client);

  Future<List<RoleModel>> fetchRoles() async {
    final raw = await client.get(Endpoints.roles) as Map<String, dynamic>;

    logger.i("👉 Raw response: $raw");

    final list = raw["data"] as List<dynamic>;
    logger.i("👉 Danh sách roles raw: $list");

    return list.map((e) => RoleModel.fromJson(e)).toList();
  }
}
