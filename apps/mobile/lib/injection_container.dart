import 'package:flutter_ios_android_platforms/domain/usecases/attendance/delete_attendance_usecase.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/grade_select/cubit/grade_select_cubit.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/attendance/attendance_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/attendance/detail_record_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/class/teaching_assignment_data_source.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/grade_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/membership_request_data_source.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/tuition/extra_fee_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/system/upload_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/user/personnel_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/user/school_admin_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/user/student_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/user/teacher_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/repositories/school/attendance/attendance_repository_impl.dart';
import 'package:flutter_ios_android_platforms/data/repositories/school/attendance/detail_record_repository_impl.dart';
import 'package:flutter_ios_android_platforms/data/repositories/school/class/teaching_assignment_impl.dart';
import 'package:flutter_ios_android_platforms/data/repositories/school/grade_repository_impl.dart';
import 'package:flutter_ios_android_platforms/data/repositories/school/membership_request_repository_impl.dart';
import 'package:flutter_ios_android_platforms/data/repositories/school/tuition/extra_fee_repositoy_impl.dart';
import 'package:flutter_ios_android_platforms/data/repositories/upload_repository_impl.dart';
import 'package:flutter_ios_android_platforms/data/repositories/user/personnel_repository_impl.dart';
import 'package:flutter_ios_android_platforms/data/repositories/user/school_admin_repository_impl.dart';
import 'package:flutter_ios_android_platforms/data/repositories/user/student_repository_impl.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/attendance/attendance_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/attendance/detail_record_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/teaching_assignment_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/grade_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/membership_request_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/tuition/extra_fee_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/upload_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/personnel_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/school_admin_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/student_repository.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/attendance/get_all_attendances_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/attendance/get_class_attendance_record_view_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/attendance/initialize_class_attendancee_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/auth/change_password_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/auth/get_roles_personnel_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/auth/get_user_profile_by_id_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/add_student_to_class_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/create_class_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/delete_class_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/get_all_class_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/get_class_by_id_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/get_class_detail_view_by_id.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/remove_student_from_class_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/transfer_class_use_case.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/update_class_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/detail_record/get_attendance_record_by_id_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/detail_record/update_status_detail_record_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/extra_fee/create_extra_fee_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/extra_fee/delete_extra_fee_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/extra_fee/get_all_extra_fee_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/extra_fee/get_extra_fee_by_id_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/extra_fee/update_extra_fee_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/grade/create_grade_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/grade/delete_grade_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/grade/get_all_grades_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/grade/get_grade_by_id_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/grade/get_grades_for_select_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/grade/update_grade_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/membership_request/create_membership_request_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/membership_request/delete_membership_request.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/membership_request/get_all_membership_request_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/membership_request/get_membership_request_by_id_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/membership_request/update_membership_request_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/membership_request/update_status_membership_request_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/personnel/dismiss_personnel_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/personnel/get_all_personnel_from_school_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/personnel/update_verified_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/school_admin/update_position_school_admin_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/student/create_student_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/student/delete_student_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/student/get_all_students_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/student/get_student_by_id_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/student/get_student_selector_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/student/update_student_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/teaching_assignment/create_teaching_assignment_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/teaching_assignment/delete_teaching_assignment_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/teaching_assignment/get_class_teacher_assignments_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/teaching_assignment/get_classes_teacher_assign_by_teacher_id_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/teaching_assignment/get_teaching_assignment_by_teacher_class_and_school_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/teaching_assignment/update_teaching_assignment_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/upload_temp_avatar_usecase.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/attendance_record/bloc/attendance_detail_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/change_password/cubit/change_password_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/forget_password/bloc/forget_password_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/role/bloc/role_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/user_profile/cubit/user_profile_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/class_detail/cubit/class_detail_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/bloc/class_member_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/student_selector/cubit/student_selector_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/teacher/cubit/teacher_classes_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_feature/teacher/bloc/teacher_attendance_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/attendance/bloc/attendance_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/class/bloc/class_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/grade/bloc/grade_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/bloc/membership_request_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/personnel/bloc/personnel_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/tuition/extra_fee/bloc/extra_fee_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/student/student_managent/bloc/student_management_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Core
import 'core/network/api_client.dart';

// Services
import 'services/firebase_auth_service.dart';
import 'services/firebase_storage_uploader.dart';
import 'services/dashboard_cache_service.dart';

// DataSources
import 'data/datasources/remote/auth/auth_remote_data_source.dart';
import 'data/datasources/remote/auth/role_remote_datasource.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/class/class_remote_data_source.dart';
import 'data/datasources/remote/school/school_remote_data_source.dart';
import 'data/datasources/remote/dashboard/school_admin_dashboard_remote_data_source.dart';

// Repositories
import 'data/repositories/auth/auth_repository_impl.dart';
import 'data/repositories/auth/role_repository_impl.dart';
import 'data/repositories/school/class/class_repository_impl.dart';
import 'data/repositories/school/school_repository_impl.dart';
import 'data/repositories/dashboard/dashboard_repository_impl.dart';

// Domain Repositories
import 'domain/repositories/auth/auth_repository.dart';
import 'domain/repositories/auth/role_repository.dart';
import 'domain/repositories/school/class/class_repository.dart';
import 'domain/repositories/school/school_repository.dart';
import 'domain/repositories/dashboard/school_admin_dashboard_repository.dart';

// UseCases - Auth
import 'domain/usecases/auth/register_user_usecase.dart';
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/get_all_roles_usecase.dart';
import 'domain/usecases/auth/get_current_user_usecase.dart';
import 'domain/usecases/auth/logout_user_usecase.dart';

// UseCases - School
import 'domain/usecases/school/create_school_usecase.dart';
import 'domain/usecases/school/delete_school_usecase.dart';
import 'domain/usecases/school/get_school_detail_for_schooladmin_usecase.dart';
import 'domain/usecases/school/get_schools_by_level_usecase.dart';
import 'domain/usecases/school/update_school_usecase.dart';

// UseCases - Class
import 'domain/usecases/class/get_all_classes_in_school_usecase.dart';

// UseCases - Dashboard
import 'domain/usecases/school_admin_dashboard/get_dashboard_overview.dart';
import 'domain/usecases/school_admin_dashboard/get_school_attendance_stats.dart';

// Blocs / Cubits
import 'core/bloc/authentication/authentication_bloc.dart';
import 'presentation/screens/auth/login/bloc/login_bloc.dart';
import 'presentation/screens/auth/registration/bloc/registration_bloc.dart';
import 'presentation/screens/auth/registration/bloc/school/school_bloc.dart';
import 'presentation/screens/common/class_selector/bloc/class_selector_bloc.dart';
import 'presentation/screens/dashboard/cubit/dashboard_cubit.dart';
import 'presentation/screens/school_admin/school/bloc/school_data_schooladmin_bloc.dart';

final sl = GetIt.instance;

Future<String?> _getIdToken() async {
  final user = FirebaseAuth.instance.currentUser;
  return await user?.getIdToken();
}

Future<void> init() async {
  // ======================
  // Core
  // ======================
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ======================
  // Services
  // ======================
  sl.registerLazySingleton<FirebaseAuthService>(
    () => FirebaseAuthServiceImpl(firebaseAuth: FirebaseAuth.instance),
  );
  sl.registerLazySingleton<FirebaseStorageUploader>(
    () => FirebaseStorageUploader(),
  );
  sl.registerLazySingleton<DashboardCacheService>(
    () => DashboardCacheService(),
  );

  // ======================
  // DataSources
  // ======================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl(), sl()),
  );
  sl.registerLazySingleton<RoleRemoteDataSource>(
    () => RoleRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<ClassRemoteDataSource>(
    () => ClassRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<SchoolRemoteDataSource>(
    () => SchoolRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<SchoolAdminDashboardRemoteDataSource>(
    () => SchoolAdminDashboardRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<MembershipRequestRemoteDataSource>(
    () => MembershipRequestRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<GradeRemoteDataSource>(
    () => GradeRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<TeachingAssignmentRemoteDataSource>(
    () => TeachingAssignmentRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<PersonnelRemoteDataSource>(
    () => PersonnelRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<SchoolAdminRemoteDataSource>(
    () => SchoolAdminRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
    () => AttendanceRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<DetailRecordRemoteDataSource>(
    () => DetailRecordRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<TeacherRemoteDataSource>(
    () => TeacherRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<UploadRemoteDataSource>(
    () => UploadRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<ExtraFeeRemoteDataSource>(
    () => ExtraFeeRemoteDataSource(client: sl(), getIdToken: _getIdToken),
  );

  // ======================
  // Repositories
  // ======================
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<RoleRepository>(() => RoleRepositoryImpl(sl()));
  sl.registerLazySingleton<ClassRepository>(() => ClassRepositoryImpl(sl()));
  sl.registerLazySingleton<SchoolRepository>(() => SchoolRepositoryImpl(sl()));
  sl.registerLazySingleton<SchoolAdminDashboardRepository>(
    () => SchoolAdminDashboardRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<MembershipRequestRepository>(
    () => MembershipRequestRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GradeRepository>(() => GradeRepositoryImpl(sl()));
  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<PersonnelRepository>(
    () => PersonnelRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<TeachingAssignmentRepository>(
    () => TeachingAssignmentRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SchoolAdminRepository>(
    () => SchoolAdminRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<DetailRecordRepository>(
    () => DetailRecordRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<UploadRepository>(() => UploadRepositoryImpl(sl()));
  sl.registerLazySingleton<ExtraFeeRepository>(
    () => ExtraFeeRepositoryImpl(sl()),
  );

  // ======================
  // UseCases
  // ======================

  // Auth
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetAllRolesUseCase(sl()));
  sl.registerLazySingleton(() => GetRolesPersonnelUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUserUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
  sl.registerLazySingleton(() => GetUserProfileByIdUseCase(sl()));

  // Class
  sl.registerLazySingleton(() => GetAllClassesInSchoolUseCase(sl()));
  sl.registerLazySingleton(() => CreateClassUseCase(sl()));
  sl.registerLazySingleton(() => UpdateClassUseCase(sl()));
  sl.registerLazySingleton(() => DeleteClassUseCase(sl()));
  sl.registerLazySingleton(() => GetClassByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetAllClassUseCase(sl()));
  sl.registerLazySingleton(() => GetClassDetailViewByIdUseCase(sl()));
  sl.registerLazySingleton(() => AddStudentToClassUseCase(sl()));
  sl.registerLazySingleton(() => RemoveStudentFromClassUseCase(sl()));
  sl.registerLazySingleton(() => TransferClassUseCase(sl()));

  // School
  sl.registerLazySingleton(() => GetSchoolsByLevelUseCase(sl()));
  sl.registerLazySingleton(() => CreateSchoolUseCase(sl()));
  sl.registerLazySingleton(() => DeleteSchoolUseCase(sl()));
  sl.registerLazySingleton(() => GetSchoolDetailForSchoolAdminUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSchoolUseCase(sl()));

  // Membership Request
  sl.registerLazySingleton(() => CreateMembershipRequestUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMembershipRequestUseCase(sl()));
  sl.registerLazySingleton(() => GetAllMembershipRequestsUseCase(sl()));
  sl.registerLazySingleton(() => GetMembershipRequestByIdUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMembershipRequestUseCase(sl()));
  sl.registerLazySingleton(() => UpdateStatusMembershipRequestUseCase(sl()));

  // Dashboard
  sl.registerLazySingleton(() => GetDashboardSummaryUseCase(sl()));
  sl.registerLazySingleton(() => GetSchoolAttendanceStatsUseCase(sl()));

  // Grade
  sl.registerLazySingleton(() => CreateGradeUseCase(sl()));
  sl.registerLazySingleton(() => DeleteGradeUseCase(sl()));
  sl.registerLazySingleton(() => GetAllGradesUseCase(sl()));
  sl.registerLazySingleton(() => GetGradeByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetGradesForSelectUseCase(sl()));
  sl.registerLazySingleton(() => UpdateGradeUseCase(sl()));

  // Student
  sl.registerLazySingleton(() => CreateStudentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteStudentUseCase(sl()));
  sl.registerLazySingleton(() => GetAllStudentsUseCase(sl()));
  sl.registerLazySingleton(() => GetStudentByIdUseCase(sl()));
  sl.registerLazySingleton(() => UpdateStudentUseCase(sl()));
  sl.registerLazySingleton(() => GetStudentSelectorUseCase(sl()));

  // Personnel
  sl.registerLazySingleton(() => GetAllPersonnelFromSchoolUseCase(sl()));
  sl.registerLazySingleton(() => UpdateVerifiedUseCase(sl()));
  sl.registerLazySingleton(() => DismissPersonnelUseCase(sl()));

  // Teaching Assignment
  sl.registerLazySingleton(() => CreateTeachingAssignmentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTeachingAssignmentUseCase(sl()));
  sl.registerLazySingleton(
    () => GetTeachingAssignmentByTeacherClassAndSchoolUseCase(sl()),
  );
  sl.registerLazySingleton(() => UpdateTeachingAssignmentUseCase(sl()));
  sl.registerLazySingleton(() => GetClassTeacherAssignmentsUseCase(sl()));
  sl.registerLazySingleton(
    () => GetClassesTeacherAssignByTeacherIdUseCase(sl()),
  );

  // School Admin
  sl.registerLazySingleton(() => UpdatePositionSchoolAdminUseCase(sl()));

  // Attendance
  sl.registerLazySingleton(() => InitializeClassAttendanceUseCase(sl()));
  sl.registerLazySingleton(() => GetClassAttendanceRecordViewUseCase(sl()));
  sl.registerLazySingleton(() => GetAllAttendancesUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAttendanceUseCase(sl()));

  // Detail Record
  sl.registerLazySingleton(() => UpdateStatusDetailRecordUseCase(sl()));
  sl.registerLazySingleton(() => GetAttendanceRecordByIdUseCase(sl()));

  // Upload
  sl.registerLazySingleton(() => UploadTempAvatarUseCase(sl()));

  // Extra Fee
  sl.registerLazySingleton(() => GetAllExtraFeeUseCase(sl()));
  sl.registerLazySingleton(() => GetExtraFeeByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateExtraFeeUseCase(sl()));
  sl.registerLazySingleton(() => UpdateExtraFeeUseCase(sl()));
  sl.registerLazySingleton(() => DeleteExtraFeeUseCase(sl()));

  // ======================
  // Blocs / Cubits
  // ======================
  sl.registerLazySingleton(
    () => AuthenticationBloc(
      getCurrentUserUseCase: sl(),
      logoutUserUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => RegistrationBloc(
      registerUserUseCase: sl(),
      uploader: sl(),
      getAllRolesUseCase: sl(),
      uploadTempAvatarUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => LoginBloc(loginUseCase: sl(), authenticationBloc: sl()),
  );
  sl.registerFactory(() => SchoolBloc(getSchoolsByLevelUseCase: sl()));
  sl.registerFactory(
    () => ClassSelectorBloc(
      getClassesBySchoolUseCase: sl(),
      getClassesByTeacherUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => DashboardCubit(
      schoolAdminRepo: sl(),
      getClassTeacherAssignmentsUseCase: sl(),
      cacheService: sl(),
      authBloc: sl(),
    ),
  );

  sl.registerFactory(
    () => SchoolDataSchoolAdminBloc(
      getSchoolDetailUseCase: sl(),
      createSchoolUseCase: sl(),
      updateSchoolUseCase: sl(),
      deleteSchoolUseCase: sl(),
      authenticationBloc: sl(),
    ),
  );

  sl.registerFactory(
    () => ClassManagementBloc(
      createClassUseCase: sl(),
      updateClassUseCase: sl(),
      deleteClassUseCase: sl(),
      getAllClassUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => MembershipRequestManagementBloc(
      getAllMembershipRequests: sl(),
      updateStatusMembershipRequest: sl(),
    ),
  );

  sl.registerFactory(() => GradeSelectCubit(sl()));
  sl.registerFactory(() => StudentSelectorCubit(sl()));

  sl.registerFactory(
    () => GradeManagementBloc(
      createGradeUseCase: sl(),
      deleteGradeUseCase: sl(),
      getAllGradesUseCase: sl(),
      updateGradeUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => StudentManagementBloc(
      createStudentUseCase: sl(),
      deleteStudentUseCase: sl(),
      getAllStudentsUseCase: sl(),
      getStudentByIdUseCase: sl(),
      updateStudentUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => PersonnelManagementBloc(
      getAllPersonnelUseCase: sl(),
      createTeachingAssignmentUseCase: sl(),
      deleteTeachingAssignmentUseCase: sl(),
      getTeachingAssignmentByTeacherClassAndSchoolUseCase: sl(),
      updateTeachingAssignmentUseCase: sl(),
      updateVerifiedUseCase: sl(),
      dismissPersonnelUseCase: sl(),
      updatePositionSchoolAdminUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => RoleBloc(getAllRolesUseCase: sl(), getRolesPersonnelUseCase: sl()),
  );

  sl.registerFactory(
    () => TeacherClassesCubit(
      initializeClassAttendanceUseCase: sl(),
      dashboardCubit: sl(),
    ),
  );

  sl.registerFactory(
    () => ClassDetailCubit(getClassDetailViewByIdUseCase: sl()),
  );

  sl.registerFactory(
    () => TeacherAttendanceBloc(
      getAttendanceRecordUseCase: sl(),
      updateStatusUseCase: sl(),
      initializeClassAttendanceUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ClassMemberBloc(
      getStudentSelectorUseCase: sl(),
      addStudentToClassUseCase: sl(),
      removeStudentFromClassUseCase: sl(),
      transferClassUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => AttendanceManagementBloc(
      getAllAttendancesUseCase: sl(),
      deleteAttendanceUseCase: sl(),
      initializeClassAttendanceUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => AttendanceDetailBloc(
      getAttendanceRecordByIdUseCase: sl(),
      updateStatusUseCase: sl(),
    ),
  );

  sl.registerFactory(() => ForgetPasswordBloc(firebaseAuthService: sl()));

  sl.registerFactory(() => ChangePasswordCubit(changePasswordUseCase: sl()));

  sl.registerFactory(
    () => UserProfileCubit(
      getUserProfileByIdUseCase: sl(),
      storageUploader: sl(),
      authBloc: sl(),
    ),
  );

  sl.registerFactory(
    () => ExtraFeeManagementBloc(
      createExtraFeeUseCase: sl(),
      deleteExtraFeeUseCase: sl(),
      getAllExtraFeeUseCase: sl(),
      updateExtraFeeUseCase: sl(),
    ),
  );
}
