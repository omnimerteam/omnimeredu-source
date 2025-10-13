import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_event.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/auth/get_user_profile_by_id_usecase.dart';
import 'package:flutter_ios_android_platforms/services/firebase_storage_uploader.dart';
import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final GetUserProfileByIdUseCase getUserProfileByIdUseCase;
  // final UpdateUserAvatarUsecase updateUserAvatarUseCase; // sẽ thêm sau
  final FirebaseStorageUploader storageUploader;
  final AuthenticationBloc authBloc;

  UserProfileCubit({
    required this.getUserProfileByIdUseCase,
    // required this.updateUserAvatarUseCase,
    required this.storageUploader,
    required this.authBloc,
  }) : super(UserProfileInitial());

  /// Load thông tin user
  Future<void> loadUserProfile(String userId) async {
    emit(UserProfileLoading());

    final response = await getUserProfileByIdUseCase.getUserProfileById(userId);

    if (response.success && response.data != null) {
      emit(UserProfileLoaded(response.data!));
    } else {
      emit(
        UserProfileError(
          response.message ?? 'Không thể tải thông tin người dùng',
        ),
      );
    }
  }

  /// Upload ảnh avatar và cập nhật state
  /// Upload ảnh avatar và cập nhật state UI
  Future<void> updateAvatar(File imageFile) async {
    if (state is! UserProfileLoaded) return;

    final currentUser = (state as UserProfileLoaded).user;

    // Emit state uploading để hiển thị progress trên UI
    emit(UserProfileAvatarUploading(currentUser));

    // Upload lên Firebase Storage
    final downloadUrl = await storageUploader.updateAvatar(imageFile);

    if (downloadUrl == null) {
      emit(UserProfileError('Upload avatar thất bại'));
      return;
    }

    // Tạo user mới với avatarUrl mới
    final updatedUser = currentUser.copyWith(avatarUrl: downloadUrl);

    // Emit state đã upload xong, UI sẽ tự refresh avatar
    emit(UserProfileAvatarUpdated(updatedUser));
    final authState = authBloc.state;
    if (authState is AuthenticationAuthenticated) {
      authBloc.add(UpdateUserAvatarEvent(downloadUrl));
    }
  }

  /// Reload user
  void refresh() {
    if (state is UserProfileLoaded) {
      final user = (state as UserProfileLoaded).user;
      if (user.id != null) {
        loadUserProfile(user.id!);
      }
    }
  }
}
