import 'package:flutter_ios_android_platforms/core/bloc/grade_select/grade_select_cubit.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/grade_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/membership_request_data_source.dart';
import 'package:flutter_ios_android_platforms/data/repositories/school/grade_repository_impl.dart';
import 'package:flutter_ios_android_platforms/data/repositories/school/membership_request_repository_impl.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/grade_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/membership_request_repository.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/create_class_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/delete_class_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/get_all_class_detail_view_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/get_class_by_id_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/update_class_usecase.dart';
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
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/class/bloc/class_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/bloc/membership_request_management_bloc.dart';
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
import 'presentation/screens/auth/registration/bloc/class/class_bloc.dart';
import 'presentation/screens/dashboard/cubit/dashboard_cubit.dart';
import 'presentation/screens/school_admin/school/bloc/school_data_schooladmin_bloc.dart';

final sl = GetIt.instance;

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

  // ======================
  // UseCases
  // ======================

  // Auth
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetAllRolesUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUserUseCase(sl()));

  // Class
  sl.registerLazySingleton(() => GetAllClassesInSchoolUseCase(sl()));
  sl.registerLazySingleton(() => CreateClassUseCase(sl()));
  sl.registerLazySingleton(() => UpdateClassUseCase(sl()));
  sl.registerLazySingleton(() => DeleteClassUseCase(sl()));
  sl.registerLazySingleton(() => GetClassByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetAllClassDetailViewUseCase(sl()));

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
    ),
  );

  sl.registerFactory(
    () => LoginBloc(loginUseCase: sl(), authenticationBloc: sl()),
  );
  sl.registerFactory(() => SchoolBloc(getSchoolsByLevelUseCase: sl()));
  sl.registerFactory(() => ClassBloc(getClassesBySchoolUseCase: sl()));
  sl.registerFactory(
    () => DashboardCubit(schoolAdminRepo: sl(), cacheService: sl()),
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
      getAllClassDetailViewUseCase: sl(),
      createClassUseCase: sl(),
      updateClassUseCase: sl(),
      deleteClassUseCase: sl(),
      getClassByIdUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => MembershipRequestManagementBloc(
      getAllMembershipRequests: sl(),
      updateStatusMembershipRequest: sl(),
    ),
  );

  sl.registerFactory(() => GradeSelectCubit(sl()));
}
