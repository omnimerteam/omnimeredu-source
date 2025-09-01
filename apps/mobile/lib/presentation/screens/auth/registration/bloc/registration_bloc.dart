import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/base_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/register_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/school_data.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/get_all_roles_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/register_user_usecase.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_state.dart';
import 'package:flutter_ios_android_platforms/services/firebase_storage_uploader.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegisterUserUseCase registerUserUseCase;
  final FirebaseStorageUploader uploader;
  final GetAllRolesUseCase getAllRolesUseCase;

  RegistrationBloc({
    required this.registerUserUseCase,
    required this.uploader,
    required this.getAllRolesUseCase,
  }) : super(RegistrationInitial()) {
    on<LoadRolesEvent>(_onLoadRoles);
    on<RegisterUserEvent>(_onRegisterUser);
    on<SearchSchoolByCodeEvent>(_onSearchSchoolByCode);
  }

  Future<void> _onLoadRoles(
    LoadRolesEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RolesLoading());

    try {
      final roles = await getAllRolesUseCase.call();
      emit(RolesLoaded(roles));
    } catch (e) {
      logger.e('Error loading roles: $e');
      emit(RolesLoadError('Không thể tải danh sách vai trò: ${e.toString()}'));
    }
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading());

    try {
      RegisterUserEntity updatedEntity = event.userEntity;

      // Upload avatar if provided
      if (event.avatarFile != null) {
        logger.i('Uploading avatar...');
        final avatarUrl = await uploader.uploadUserAvatar(
          event.avatarFile!,
          uidOrRandom: DateTime.now().millisecondsSinceEpoch.toString(),
        );

        // Update entity with avatar URL
        updatedEntity = RegisterUserEntity(
          email: event.userEntity.email,
          password: event.userEntity.password,
          baseUserInfo: BaseUserEntity(
            roleId: event.userEntity.baseUserInfo.roleId,
            fullName: event.userEntity.baseUserInfo.fullName,
            gender: event.userEntity.baseUserInfo.gender,
            phone: event.userEntity.baseUserInfo.phone,
            birthday: event.userEntity.baseUserInfo.birthday,
            address: event.userEntity.baseUserInfo.address,
            avatarUrl: avatarUrl,
          ),
          schoolId: event.userEntity.schoolId,
          specificInfo: event.userEntity.specificInfo,
          schoolData: event.userEntity.schoolData,
        );
      }

      // Upload school logo if provided
      if (event.schoolLogoFile != null && event.userEntity.schoolData != null) {
        logger.i('Uploading school logo...');
        final logoUrl = await uploader.uploadSchoolLogo(
          event.schoolLogoFile!,
          schoolKey: event.userEntity.schoolData!.code,
        );

        // Update school data with logo URL
        updatedEntity = RegisterUserEntity(
          email: updatedEntity.email,
          password: updatedEntity.password,
          baseUserInfo: updatedEntity.baseUserInfo,
          schoolId: updatedEntity.schoolId,
          specificInfo: updatedEntity.specificInfo,
          schoolData: SchoolDataEntity(
            id: updatedEntity.schoolData!.id,
            name: updatedEntity.schoolData!.name,
            code: updatedEntity.schoolData!.code,
            address: updatedEntity.schoolData!.address,
            phone: updatedEntity.schoolData!.phone,
            description: updatedEntity.schoolData!.description,
            level: updatedEntity.schoolData!.level,
            logoUrl: logoUrl,
          ),
        );
      }

      // Register user
      await registerUserUseCase.call(updatedEntity);
      emit(RegistrationSuccess());
    } catch (e) {
      logger.e('Registration error: $e');
      emit(
        RegistrationError('${e.toString().replaceFirst("Exception: ", "")}'),
      );
    }
  }

  Future<void> _onSearchSchoolByCode(
    SearchSchoolByCodeEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(SchoolSearchLoading());

    try {
      // TODO: Implement school search API call
      // For now, return mock data
      await Future.delayed(const Duration(seconds: 1));

      // Mock school data
      final schoolInfo = {
        'id': 'school_${event.code}',
        'name': 'Trường THPT ${event.code}',
        'code': event.code,
        'address': 'Địa chỉ trường ${event.code}',
        'level': 'HighSchool',
      };

      emit(SchoolSearchSuccess(schoolInfo));
    } catch (e) {
      logger.e('School search error: $e');
      emit(SchoolSearchError('Không tìm thấy trường với mã: ${event.code}'));
    }
  }
}
