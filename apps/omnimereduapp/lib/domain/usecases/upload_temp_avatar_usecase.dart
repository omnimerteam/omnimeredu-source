import 'dart:io';
import '../../core/network/api_response.dart';
import '../repositories/upload_repository.dart';

/// UseCase chịu trách nhiệm upload ảnh tạm (avatar)
class UploadTempAvatarUseCase {
  final UploadRepository repository;

  UploadTempAvatarUseCase(this.repository);

  /// [file] là file ảnh cần upload.
  /// Trả về [ApiResponse] chứa thông tin upload (link tạm hoặc metadata)
  Future<ApiResponse<Map<String, dynamic>>> call(File file) async {
    if (!file.existsSync()) {
      return ApiResponse(
        success: false,
        message: "File không tồn tại",
        data: null,
      );
    }

    return await repository.uploadTempAvatar(file);
  }
}
