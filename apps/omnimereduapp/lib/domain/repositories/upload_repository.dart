import 'dart:io';
import '../../core/network/api_response.dart';

abstract class UploadRepository {
  Future<ApiResponse<Map<String, dynamic>>> uploadTempAvatar(File file);
}
