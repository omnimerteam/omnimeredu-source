import 'dart:io';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/network/api_client.dart';

class UploadRemoteDataSource {
  final ApiClient client;

  UploadRemoteDataSource(this.client);

  Future<ApiResponse<Map<String, dynamic>>> uploadTempAvatar(File file) async {
    return await client.uploadFile<Map<String, dynamic>>(
      Endpoints.uploadAvatar,
      file: file,
      fieldName: 'file',
      parser: (data) => Map<String, dynamic>.from(data),
    );
  }
}
