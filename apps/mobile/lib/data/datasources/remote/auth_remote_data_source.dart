import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/endpoints.dart';
import '../../models/base_user_model.dart';
import '../../models/role_specific_model.dart';
import '../../models/school_data_model.dart';

class AuthRemoteDataSource {
  final ApiClient client;
  AuthRemoteDataSource(this.client);

  Future<void> register({
    required String email,
    required String password,
    String? schoolId,
    String? classId,
    required BaseUserModel baseUserInfo,
    required RoleSpecificModel specificInfo,
    SchoolDataModel? schoolData,
  }) async {
    final payload = {
      'email': email,
      'password': password,
      if (schoolId != null) 'schoolId': schoolId,
      if (classId != null) 'classId': classId,
      'baseUserInfo': baseUserInfo.toJson(),
      'specificInfo': specificInfo.toJson(),
      if (schoolData != null) 'schoolData': schoolData.toJson(),
    };

    final Response res = await client.post(Endpoints.register, data: payload);
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Register failed: ${res.statusCode}');
    }
  }
}
