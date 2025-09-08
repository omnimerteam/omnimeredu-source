import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import '../../../models/role_model.dart';
import '../../../../core/network/endpoints.dart';

class RoleRemoteDataSource {
  final ApiClient client;

  RoleRemoteDataSource(this.client);

  Future<List<RoleModel>> fetchRoles() async {
    try {
      final raw = await client.get(Endpoints.roles);

      if (raw.success != true) {
        throw Exception(raw.message ?? "Không thể lấy roles");
      }

      final nested = raw.data;
      if (nested is Map<String, dynamic> && nested["data"] is List) {
        final list = (nested["data"] as List)
            .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return list;
      }

      throw Exception("Dữ liệu roles không hợp lệ: ${raw.data}");
    } catch (e) {
      logger.e("❌ Exception khi fetch roles: $e");
      throw Exception("Lỗi khi fetch roles: $e");
    }
  }
}
