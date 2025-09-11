import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/class/class_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/dashboard/school_admin_dashboard_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/school/school_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/data/repositories/class_repository_impl.dart';
import 'package:flutter_ios_android_platforms/data/repositories/dashboard_repository_impl.dart';
import 'package:flutter_ios_android_platforms/data/repositories/school_repository_impl.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/dashboard/school_admin_dashboard_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/class/class_repository.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/school_repository.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/auth/logout_user_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/get_all_classes_in_school_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/school/create_school_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/school/delete_school_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/school/get_school_detail_for_schooladmin_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/school/get_schools_by_level_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/school/update_school_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/school_admin_dashboard/get_dashboard_overview.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/school_admin_dashboard/get_school_attendance_stats.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/class/class_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/school/school_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school/bloc/school_data_schooladmin_bloc.dart';
import 'package:flutter_ios_android_platforms/services/dashboard_cache_service.dart';
import 'package:get_it/get_it.dart';

import 'core/network/api_client.dart';

// DataSources
import 'data/datasources/remote/auth/auth_remote_data_source.dart';
import 'data/datasources/remote/auth/role_remote_datasource.dart';

// Repositories
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/role_repository_impl.dart';
import 'domain/repositories/auth/auth_repository.dart';
import 'domain/repositories/auth/role_repository.dart';

// UseCases
import 'domain/usecases/auth/register_user_usecase.dart';
import 'domain/usecases/auth/get_all_roles_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/auth/login_usecase.dart';

// Services
import 'services/firebase_storage_uploader.dart';
import 'package:flutter_ios_android_platforms/services/firebase_auth_service.dart';

// Blocs
import 'presentation/screens/auth/registration/bloc/registration_bloc.dart';
import 'presentation/screens/auth/login/bloc/login_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ======================
  // Core
  // ======================
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ======================
  // Services
  // ======================
  sl.registerLazySingleton<FirebaseStorageUploader>(
    () => FirebaseStorageUploader(),
  );

  sl.registerLazySingleton<FirebaseAuthService>(
    () => FirebaseAuthServiceImpl(firebaseAuth: FirebaseAuth.instance),
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

  // ======================
  // UseCases
  // ======================
  sl.registerLazySingleton<RegisterUserUseCase>(
    () => RegisterUserUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<GetAllRolesUseCase>(
    () => GetAllRolesUseCase(sl<RoleRepository>()),
  );

  sl.registerLazySingleton<GetAllClassesInSchoolUseCase>(
    () => GetAllClassesInSchoolUseCase(sl<ClassRepository>()),
  );

  sl.registerLazySingleton<GetSchoolsByLevelUseCase>(
    () => GetSchoolsByLevelUseCase(sl<SchoolRepository>()),
  );

  sl.registerLazySingleton<LogoutUserUseCase>(
    () => LogoutUserUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<GetDashboardSummaryUseCase>(
    () => GetDashboardSummaryUseCase(sl<SchoolAdminDashboardRepository>()),
  );
  sl.registerLazySingleton<GetSchoolAttendanceStatsUseCase>(
    () => GetSchoolAttendanceStatsUseCase(sl<SchoolAdminDashboardRepository>()),
  );

  sl.registerLazySingleton<CreateSchoolUseCase>(
    () => CreateSchoolUseCase(sl<SchoolRepository>()),
  );

  sl.registerLazySingleton<DeleteSchoolUseCase>(
    () => DeleteSchoolUseCase(sl<SchoolRepository>()),
  );

  sl.registerLazySingleton<GetSchoolDetailForSchoolAdminUseCase>(
    () => GetSchoolDetailForSchoolAdminUseCase(sl<SchoolRepository>()),
  );

  sl.registerLazySingleton<UpdateSchoolUseCase>(
    () => UpdateSchoolUseCase(sl<SchoolRepository>()),
  );

  // ======================
  // Blocs
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
}
