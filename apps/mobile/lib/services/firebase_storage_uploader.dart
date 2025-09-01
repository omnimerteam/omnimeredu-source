import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageUploader {
  final FirebaseStorage _defaultBucket;
  // Nếu dùng nhiều bucket, có thể tạo thêm instance khác:
  // final FirebaseStorage _avatarBucket = FirebaseStorage.instanceFor(bucket: 'gs://avatar-bucket');
  // final FirebaseStorage _schoolBucket = FirebaseStorage.instanceFor(bucket: 'gs://school-bucket');

  FirebaseStorageUploader({FirebaseStorage? storage})
    : _defaultBucket = storage ?? FirebaseStorage.instance;

  Future<String> uploadUserAvatar(
    File file, {
    required String uidOrRandom,
  }) async {
    final ref = _defaultBucket.ref().child('avatar_user/$uidOrRandom');
    final task = await ref.putFile(
      file,
      SettableMetadata(cacheControl: 'public,max-age=86400'),
    );
    return task.ref.getDownloadURL();
  }

  Future<String> uploadSchoolLogo(
    File file, {
    required String schoolKey,
  }) async {
    final ref = _defaultBucket.ref().child('logo_school/$schoolKey');
    final task = await ref.putFile(
      file,
      SettableMetadata(cacheControl: 'public,max-age=86400'),
    );
    return task.ref.getDownloadURL();
  }
}
