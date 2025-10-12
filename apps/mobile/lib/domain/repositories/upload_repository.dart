import 'dart:io';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';

abstract class UploadRepository {
  Future<ApiResponse<Map<String, dynamic>>> uploadTempAvatar(File file);
}
