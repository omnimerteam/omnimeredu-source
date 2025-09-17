import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/base_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/register_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/school/school_data_entity.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/auth/get_all_roles_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/auth/register_user_usecase.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/services/firebase_storage_uploader.dart';

import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final GetAllRolesUseCase getAllRolesUseCase;
  final RegisterUserUseCase registerUserUseCase;
  final FirebaseStorageUploader uploader;

  RegistrationBloc({
    required this.getAllRolesUseCase,
    required this.uploader,
    required this.registerUserUseCase,
  }) : super(const RegistrationState()) {
    on<LoadRolesEvent>(_onLoadRoles);
    on<UpdateBasicInfoEvent>(_onUpdateBasicInfo);
    on<UpdateRoleEvent>(_onUpdateRole);
    on<UpdateStudentInfoEvent>(_onUpdateStudentInfo);
    on<UpdateTeacherInfoEvent>(_onUpdateTeacherInfo);
    on<UpdateSchoolAdminInfoEvent>(_onUpdateSchoolAdminInfo);
    on<SubmitRegistrationEvent>(_onSubmitRegistration);
    on<UpdateSchoolIdEvent>(_onUpdateSchoolId);
    on<UpdateClassIdEvent>(_onUpdateClassId);
    on<UpdateSelectedEducationLevelEvent>(_onSelectedEducationLevel);
    on<ResetRegistration>((event, emit) {
      emit(RegistrationState.initial()); // quay về state gốc
    });
  }

  /// Load roles từ API
  Future<void> _onLoadRoles(
    LoadRolesEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final roles = await getAllRolesUseCase.call();
      emit(
        state.copyWith(
          roles: roles,
          loading: false,
          selectedRoleId: roles[0].id,
          selectedRoleName: roles[0].name,
        ),
      );
    } catch (error) {
      logger.e("Lỗi load roles", error: error);
      emit(state.copyWith(loading: false, error: error.toString()));
    }
  }

  void _onUpdateBasicInfo(
    UpdateBasicInfoEvent event,
    Emitter<RegistrationState> emit,
  ) {
    emit(
      state.copyWith(
        email: event.email ?? state.email,
        password: event.password ?? state.password,
        fullName: event.fullName ?? state.fullName,
        gender: event.gender ?? state.gender,
        birthday: event.birthday ?? state.birthday,
        phone: event.phone ?? state.phone,
        address: event.address ?? state.address,
        avatarFile: event.avatarFile ?? state.avatarFile,
      ),
    );
  }

  void _onUpdateRole(UpdateRoleEvent event, Emitter<RegistrationState> emit) {
    emit(
      state.copyWith(
        selectedRoleId: event.roleId,
        selectedRoleName: event.roleName ?? state.selectedRoleName,
      ),
    );
  }

  void _onSelectedEducationLevel(
    UpdateSelectedEducationLevelEvent event,
    Emitter<RegistrationState> emit,
  ) {
    emit(
      state.copyWith(
        selectedEducationLevel:
            event.selectedEducationLevel ?? state.selectedEducationLevel,
      ),
    );
  }

  void _onUpdateSchoolId(
    UpdateSchoolIdEvent event,
    Emitter<RegistrationState> emit,
  ) {
    emit(
      state.copyWith(
        schoolId: event.schoolId ?? state.schoolId,
        assignSchoolName: event.assignSchoolName ?? state.assignSchoolName,
      ),
    );
  }

  void _onUpdateClassId(
    UpdateClassIdEvent event,
    Emitter<RegistrationState> emit,
  ) {
    emit(
      state.copyWith(
        classId: event.classId ?? state.classId,
        assignClassName: event.assignClassName ?? state.assignClassName,
      ),
    );
  }

  void _onUpdateStudentInfo(
    UpdateStudentInfoEvent event,
    Emitter<RegistrationState> emit,
  ) {
    emit(
      state.copyWith(
        guardianName: event.guardianName ?? state.guardianName,
        guardianPhone: event.guardianPhone ?? state.guardianPhone,
        educationLevel: event.educationLevel ?? state.educationLevel,
        grade: event.grade ?? state.grade,
      ),
    );
  }

  void _onUpdateTeacherInfo(
    UpdateTeacherInfoEvent event,
    Emitter<RegistrationState> emit,
  ) {
    emit(
      state.copyWith(
        qualification: event.qualification ?? state.qualification,
        subjects: event.subjects ?? state.subjects,
      ),
    );
  }

  void _onUpdateSchoolAdminInfo(
    UpdateSchoolAdminInfoEvent event,
    Emitter<RegistrationState> emit,
  ) {
    emit(
      state.copyWith(
        isCreateNewSchool: event.isCreateNewSchool,
        position: event.position ?? state.position,
        schoolName: event.schoolName ?? state.schoolName,
        schoolAddress: event.schoolAddress ?? state.schoolAddress,
        schoolPhone: event.schoolPhone ?? state.schoolPhone,
        schoolDescription: event.schoolDescription ?? state.schoolDescription,
        schoolLevel: event.schoolLevel ?? state.schoolLevel,
        schoolLogoFile: event.schoolLogoFile ?? state.schoolLogoFile,
      ),
    );
  }

  Future<void> _onSubmitRegistration(
    SubmitRegistrationEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: true, error: null));

      String? avatarUrl;
      String? logoUrl;

      // Upload avatar nếu có
      if (state.avatarFile != null) {
        avatarUrl = await uploader.uploadUserAvatar(
          state.avatarFile!,
          uidOrRandom:
              state.email ?? DateTime.now().millisecondsSinceEpoch.toString(),
        );
      }

      // Upload logo nếu có
      if (state.schoolLogoFile != null) {
        logoUrl = await uploader.uploadSchoolLogo(
          state.schoolLogoFile!,
          schoolKey: state.schoolId ?? "default_school",
        );
      }

      // Build entity từ state
      final user = RegisterUserEntity(
        email: state.email ?? "",
        password: state.password ?? "",
        schoolId: state.schoolId,
        classId: state.classId,
        baseUserInfo: BaseUserEntity(
          roleId: state.selectedRoleId ?? "",
          fullName: state.fullName ?? "",
          gender: state.gender ?? "Other",
          phone: state.phone,
          birthday: state.birthday,
          address: state.address,
          avatarUrl: avatarUrl,
        ),
        specificInfo: {
          // Student
          "guardianName": state.guardianName,
          "guardianPhone": state.guardianPhone,
          "educationLevel": state.educationLevel,
          // Teacher
          "qualification": state.qualification,
          "subjects": state.subjects,
          // School Admin
          "position": state.position,
        },
        schoolData: state.isCreateNewSchool
            ? SchoolDataEntity(
                id: "", // để server tự sinh
                name: state.schoolName ?? "",
                address: state.schoolAddress ?? "",
                phone: state.schoolPhone,
                description: state.schoolDescription,
                level: state.schoolLevel ?? "Preschool",
                logoUrl: logoUrl, // nếu có upload thì để backend xử lý
              )
            : null,
      );

      await registerUserUseCase.call(user);

      emit(state.copyWith(loading: false, success: true));
    } catch (error) {
      logger.e("Lỗi submit registration", error: error);
      emit(state.copyWith(loading: false, error: error.toString()));
    }
  }
}
