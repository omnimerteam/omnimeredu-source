import 'dart:io';
import '../../core/network/api_response.dart';
import '../datasources/remote/system/upload_remote_data_source.dart';
import '../../domain/repositories/upload_repository.dart';

class UploadRepositoryImpl implements UploadRepository {
  final UploadRemoteDataSource remoteDataSource;

  UploadRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResponse<Map<String, dynamic>>> uploadTempAvatar(File file) async {
    return await remoteDataSource.uploadTempAvatar(file);
  }
}
