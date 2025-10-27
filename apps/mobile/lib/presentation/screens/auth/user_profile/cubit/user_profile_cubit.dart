import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_event.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/core/utils/usecase_executor_mixin.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/school_admin_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/staff_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/student_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/teacher_entity.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/auth/get_user_profile_by_id_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/personnel/update_avatar_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/user/update_profile_usecase.dart';
import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final GetUserProfileByIdUseCase getUserProfileByIdUseCase;
  final UpdateAvatarUseCase updateAvatarUseCase;
  final AuthenticationBloc authBloc;
  final UpdateProfileUseCase updateProfileUseCase;

  UserProfileCubit({
    required this.getUserProfileByIdUseCase,
    required this.updateAvatarUseCase,
    required this.authBloc,
    required this.updateProfileUseCase,
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

  /// Upload ảnh avatar và cập nhật state UI
  Future<void> updateAvatar(File imageFile) async {
    if (state is! UserProfileLoaded) return;

    final currentUser = (state as UserProfileLoaded).user;

    // Emit state uploading để hiển thị progress trên UI
    emit(UserProfileAvatarUploading(currentUser));

    // Upload lên Firebase Storage
    final avatarUrl = await updateAvatarUseCase.call(imageFile);

    if (avatarUrl == null) {
      emit(UserProfileError('Upload avatar thất bại'));
      return;
    }

    // Tạo user mới với avatarUrl mới
    final updatedUser = currentUser.copyWith(avatarUrl: avatarUrl);

    // Emit state đã upload xong, UI sẽ tự refresh avatar
    emit(UserProfileAvatarUpdated(updatedUser));
    final authState = authBloc.state;
    if (authState is AuthenticationAuthenticated) {
      authBloc.add(UpdateUserAvatarEvent(avatarUrl));
    }
  }

  /// Cập nhật thông tin người dùng (ví dụ: tên, email, số điện thoại, v.v.)
  Future<void> updateProfile({required dynamic updatedUserData}) async {
    if (state is! UserProfileLoaded) return;

    final currentUser = (state as UserProfileLoaded).user;
    emit(UserProfileUpdating(currentUser));

    try {
      // Lấy user hiện tại từ AuthenticationBloc
      final authState = authBloc.state;
      if (authState is! AuthenticationAuthenticated) {
        emit(UserProfileError('Không tìm thấy thông tin người dùng hiện tại'));
        return;
      }

      final AuthUserEntity user = authState.user;

      // Đảm bảo đúng ID người hiện tại
      updatedUserData = updatedUserData.copyWith(id: user.id);

      // Gọi UseCase tương ứng với vai trò
      final response = await updateProfileUseCase.call(
        roleName: user.roleName,
        userData: updatedUserData,
      );

      if (response.success && response.data != null) {
        final updatedEntity = response.data!;

        // ✅ Chuyển đổi sang AuthUserEntity tùy theo loại entity
        final updatedAuthUser = _mapToAuthUserEntity(
          updatedEntity,
          user.roleName,
        );

        // Emit state cập nhật thành công
        emit(UserProfileUpdated(updatedEntity));

        // Đồng bộ lại AuthenticationBloc
        authBloc.add(UpdateUserProfileEvent(updatedAuthUser));
      } else {
        emit(UserProfileError(response.message ?? 'Cập nhật thất bại'));
      }
    } catch (e) {
      logger.e(e.toString());
      emit(UserProfileError('Lỗi khi cập nhật: $e'));
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

  AuthUserEntity _mapToAuthUserEntity(dynamic entity, String roleName) {
    switch (roleName) {
      case "Student":
        final e = entity as StudentEntity;
        return AuthUserEntity(
          id: e.id ?? '',
          fullName: e.fullName,
          roleName: roleName,
          isVerified: e.isVerified,
          educationLevel: e.educationLevel,
          gradeGroup: e.gradeGroup,
        );

      case "Teacher":
        final e = entity as TeacherEntity;
        return AuthUserEntity(
          id: e.id ?? '',
          fullName: e.fullName,
          roleName: roleName,
          isVerified: e.isVerified,
          qualification: e.qualification,
        );

      case "SchoolAdmin":
        final e = entity as SchoolAdminEntity;
        return AuthUserEntity(
          id: e.id ?? '',
          fullName: e.fullName,
          roleName: roleName,
          isVerified: e.isVerified,
          position: e.position,
        );

      case "Staff":
        final e = entity as StaffEntity;
        return AuthUserEntity(
          id: e.id ?? '',
          fullName: e.fullName,
          roleName: roleName,
          isVerified: e.isVerified,
        );

      default:
        throw UnsupportedError('Vai trò không được hỗ trợ: $roleName');
    }
  }
}
