import '../../../../../core/errors/failures.dart';
import '../../../../../core/typedefs.dart';
import '../../../../../domain/repositories/upload_repository.dart';
import 'dart:io';
import 'package:dartz/dartz.dart';

class UploadTempAvatarUseCase {
  final UploadRepository repository;

  UploadTempAvatarUseCase(this.repository);

  FutureResult<Map<String, dynamic>> call(File imageFile) async {
    return await repository.uploadTempAvatar(imageFile);
  }
}