import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/domain/entities/base_user.dart';
import 'package:flutter_ios_android_platforms/domain/entities/role_specific.dart';
import 'package:flutter_ios_android_platforms/domain/entities/school_data.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/auth_repository.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/get_all_roles_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/register_user_usecase.dart';
import 'package:flutter_ios_android_platforms/services/firebase_storage_uploader.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegisterUserUseCase registerUserUseCase;
  final FirebaseStorageUploader uploader;
  final GetAllRolesUseCase getAllRolesUseCase;

  RegistrationBloc({
    required this.registerUserUseCase,
    required this.uploader,
    required this.getAllRolesUseCase,
  }) : super(const RegistrationState()) {
    on<RegistrationEmailChanged>(
      (e, emit) => emit(state.copyWith(email: e.value, clearError: true)),
    );
    on<RegistrationPasswordChanged>(
      (e, emit) => emit(state.copyWith(password: e.value, clearError: true)),
    );
    on<RegistrationFullNameChanged>(
      (e, emit) => emit(state.copyWith(fullName: e.value, clearError: true)),
    );
    on<RegistrationRoleIdChanged>(
      (e, emit) => emit(state.copyWith(roleId: e.value)),
    );
    on<RegistrationGenderChanged>(
      (e, emit) => emit(state.copyWith(gender: e.value)),
    );
    on<RegistrationPhoneChanged>(
      (e, emit) => emit(state.copyWith(phone: e.value)),
    );
    on<RegistrationBirthdayChanged>(
      (e, emit) => emit(state.copyWith(birthday: e.value)),
    );
    on<RegistrationAddressChanged>(
      (e, emit) => emit(state.copyWith(address: e.value)),
    );
    on<RegistrationSchoolIdChanged>(
      (e, emit) => emit(state.copyWith(schoolId: e.value)),
    );
    on<RegistrationClassIdChanged>(
      (e, emit) => emit(state.copyWith(classId: e.value)),
    );
    on<RegistrationSpecificInfoChanged>(
      (e, emit) => emit(state.copyWith(specificInfo: e.map)),
    );

    on<RegistrationPickAvatar>(
      (e, emit) => emit(state.copyWith(avatarFile: e.file)),
    );
    on<RegistrationPickSchoolLogo>(
      (e, emit) => emit(state.copyWith(schoolLogoFile: e.file)),
    );

    on<RegistrationSubmitted>(_onSubmitted);

    on<RegistrationLoadRoles>(_onLoadRoles);
  }

  Future<void> _onLoadRoles(
    RegistrationLoadRoles event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final roles = await getAllRolesUseCase();
      logger.i("Roles nhận được: $roles");
      emit(state.copyWith(roles: roles, loading: false));
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: 'Không thể tải danh sách vai trò',
        ),
      );
    }
  }

  Future<void> _onSubmitted(
    RegistrationSubmitted e,
    Emitter<RegistrationState> emit,
  ) async {
    if (state.email.isEmpty ||
        state.password.isEmpty ||
        state.fullName.isEmpty ||
        state.roleId.isEmpty) {
      emit(
        state.copyWith(
          error: 'Vui lòng điền đủ Email, Mật khẩu, Họ tên, Role',
          loading: false,
        ),
      );
      return;
    }

    emit(state.copyWith(loading: true, error: null, success: false));

    try {
      String? avatarUrl;
      String? logoUrl;

      // 1) Upload avatar (nếu có)
      if (state.avatarFile != null && state.avatarFile is File) {
        final key = DateTime.now().millisecondsSinceEpoch.toString();
        avatarUrl = await uploader.uploadUserAvatar(
          state.avatarFile!,
          uidOrRandom: key,
        );
      }

      // 2) Upload school logo (nếu có)
      if (state.schoolLogoFile != null && state.schoolLogoFile is File) {
        final key = DateTime.now().millisecondsSinceEpoch.toString();
        logoUrl = await uploader.uploadSchoolLogo(
          state.schoolLogoFile!,
          schoolKey: key,
        );
      }

      // 3) Build Entities
      final baseUser = BaseUserEntity(
        roleId: state.roleId,
        fullName: state.fullName,
        gender: state.gender,
        phone: state.phone,
        birthday: state.birthday,
        address: state.address,
        avatarUrl: avatarUrl,
      );

      final specific = RoleSpecificEntity(state.specificInfo);

      SchoolDataEntity? school;
      if (state.schoolId == null && state.schoolLogoFile != null) {
        // Nếu không có schoolId mà có logo => có thể là tạo mới school kèm logo
        // Trên UI ta sẽ có form nhập name/code/address/level trong specificInfo hoặc tab riêng.
        // Ở đây demo đọc từ specificInfo (nếu có) – hoặc có thể bind field riêng.
        school = SchoolDataEntity(
          name: (state.specificInfo['schoolName'] ?? '') as String,
          code: (state.specificInfo['schoolCode'] ?? '') as String,
          address: (state.specificInfo['schoolAddress'] ?? '') as String,
          level: (state.specificInfo['schoolLevel'] ?? 'Secondary') as String,
          logoUrl: logoUrl,
        );
      }

      // 4) Call UseCase → Repository → Remote API
      await registerUserUseCase.call(
        RegisterRequestEntity(
          email: state.email,
          password: state.password,
          schoolId: state.schoolId,
          classId: state.classId,
          baseUserInfo: baseUser,
          specificInfo: specific,
          schoolData: school,
        ),
      );

      emit(state.copyWith(loading: false, success: true));
    } catch (err) {
      emit(
        state.copyWith(loading: false, error: err.toString(), success: false),
      );
    }
  }
}
