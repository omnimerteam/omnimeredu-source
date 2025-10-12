import 'dart:io';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/system/upload_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/upload_repository.dart';

class UploadRepositoryImpl implements UploadRepository {
  final UploadRemoteDataSource remoteDataSource;

  UploadRepositoryImpl(this.remoteDataSource);

  @override
  Future<ApiResponse<Map<String, dynamic>>> uploadTempAvatar(File file) async {
    return await remoteDataSource.uploadTempAvatar(file);
  }
}
