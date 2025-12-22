import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/enum_constant.dart';
import '../../../../../domain/entities/auth/register_user_entity.dart';
import '../../../../../domain/entities/school/school_data_entity.dart';

import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(const RegistrationState()) {
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
    emit(state.copyWith(selectedRole: event.role));
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
    // Check if education level is changing (and not null), and no new grade is provided -> Reset grade
    final bool shouldResetGrade =
        event.educationLevel != null &&
        event.educationLevel != state.educationLevel &&
        event.gradeGroup == null;

    emit(
      state.copyWith(
        guardianName: event.guardianName ?? state.guardianName,
        guardianPhone: event.guardianPhone ?? state.guardianPhone,
        educationLevel: event.educationLevel ?? state.educationLevel,
        gradeGroup: event.gradeGroup ?? state.gradeGroup,
        forceNullGradeGroup: shouldResetGrade,
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

      // ✅ Build entity gửi backend đăng ký
      final user = RegisterUserEntity(
        email: state.email ?? "",
        password: state.password ?? "",
        schoolId: state.schoolId,
        classId: state.classId,
        baseUserInfo: BaseUserForRegisterEntity(
          roleName: state.selectedRole?.name ?? "",
          fullName: state.fullName ?? "",
          gender: state.gender ?? "Other",
          phone: state.phone,
          birthday: state.birthday,
          address: state.address,
          avatar: state.avatarFile, // File sẽ được gửi trực tiếp về backend
        ),
        specificInfo: {
          // Student
          "guardianName": state.guardianName,
          "guardianPhone": state.guardianPhone,
          "educationLevel": state.educationLevel?.name,
          "gradeGroup": state.gradeGroup?.name,

          // Teacher
          "qualification": state.qualification?.name,
          "subjects": state.subjects?.map((s) => s.name).toList(),
          // School Admin
          "position": state.position?.name,
        },
        schoolData: state.isCreateNewSchool
            ? SchoolDataEntity(
                name: state.schoolName ?? "",
                address: state.schoolAddress ?? "",
                phone: state.schoolPhone,
                description: state.schoolDescription,
                level: state.schoolLevel ?? EducationSystemLevelsEnum.Preschool,
              )
            : null,
      );

      emit(state.copyWith(loading: false, success: true));
    } catch (error) {
      emit(state.copyWith(loading: false, error: error.toString()));
    }
  }
}
