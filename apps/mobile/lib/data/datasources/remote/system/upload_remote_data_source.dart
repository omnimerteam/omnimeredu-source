import 'dart:io';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/core/network/api_client.dart';

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
