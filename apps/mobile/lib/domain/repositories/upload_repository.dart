import '../../core/errors/failures.dart';
import '../../core/typedefs.dart';
import 'dart:io';
import 'package:dartz/dartz.dart';

abstract class UploadRepository {
  FutureResult<Map<String, dynamic>> uploadTempAvatar(File imageFile);
}