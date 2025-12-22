import 'dart:io';
import '../../../../core/add_jwt.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../base_remote_data_source.dart';

class UploadRemoteDataSource extends BaseRemoteDataSource {
  UploadRemoteDataSource(ApiClient client, AppAuthProvider authProvider)
    : super(client, authProvider);

  Future<ApiResponse<Map<String, dynamic>>> uploadTempAvatar(File file) async {
    final headers = await authHeaders;
    return await client.uploadFile<Map<String, dynamic>>(
      Endpoints.uploadAvatar,
      file: file,
      fieldName: 'file',
      headers: headers,
      parser: (data) => Map<String, dynamic>.from(data),
    );
  }
}
