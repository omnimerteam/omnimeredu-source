import 'dart:io';
import '../../repositories/user/personnel_repository.dart';
import '../../../services/firebase_storage_uploader.dart';

class UpdateAvatarUseCase {
  final PersonnelRepository repository;
  final FirebaseStorageUploader firebaseService;

  UpdateAvatarUseCase({
    required this.repository,
    required this.firebaseService,
  });

  Future<String?> call(File file) async {
    final result = await firebaseService.uploadAvatar(file);
    final path = result?['path'];
    final url = result?['url'];

    if (path == null || url == null) return null;

    await repository.updateAvatar(path, url);

    return url;
  }
}
