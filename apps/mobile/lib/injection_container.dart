import 'package:get_it/get_it.dart';
import 'package:mobile/domain/repositories/school/school_repository.dart';

import 'core/api/api_client.dart';
import 'services/secure_storage_service.dart';

import 'data/datasources/remote/auth/auth_remote_data_source.dart';
import 'data/datasources/remote/auth/role_remote_datasource.dart';
import 'data/datasources/remote/school/school_remote_data_source.dart';
import 'data/datasources/remote/school/class_remote_data_source.dart';

import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/role_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/role_repository_impl.dart';
import 'data/repositories/school_repository_impl.dart';
import 'data/datasources/remote/user/school_admin_remote_data_source.dart';
import 'data/repositories/user/school_admin_repository_impl.dart';
import 'domain/repositories/class_repository.dart';
import 'data/repositories/class_repository_impl.dart';

import 'domain/repositories/user/school_admin_repository.dart';

import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/logout_usecase.dart';
import 'domain/usecases/auth/get_current_user_usecase.dart';
import 'domain/usecases/auth/register_user_usecase.dart';
import 'domain/usecases/school/get_schools_by_level_usecase.dart';
import 'domain/usecases/school/get_classes_by_school_usecase.dart';

import 'presentation/common/blocs/auth_bloc/auth_bloc.dart';
import 'presentation/screen/auth/registration/bloc/school/school_bloc.dart';
import 'presentation/screen/auth/registration/bloc/class/class_bloc.dart';
import 'presentation/screen/school_admin/school/bloc/school_bloc.dart'
    as school_admin; // Alias to avoid conflict if any, but class names are different now.
import 'domain/usecases/school/get_school_detail_for_schooladmin_usecase.dart';
import 'domain/usecases/school/create_school_usecase.dart';
import 'domain/usecases/school/update_school_usecase.dart';
import 'domain/usecases/school/delete_school_usecase.dart';

import 'data/datasources/remote/grade/grade_remote_data_source.dart';
import 'domain/repositories/grade/grade_repository.dart';
import 'data/repositories/grade/grade_repository_impl.dart';
import 'domain/usecases/grade/get_all_grades_usecase.dart';
import 'domain/usecases/grade/create_grade_usecase.dart';
import 'domain/usecases/grade/update_grade_usecase.dart';
import 'domain/usecases/grade/delete_grade_usecase.dart';
import 'presentation/screen/school_admin/grade/bloc/grade_management_bloc.dart';
import 'presentation/screen/school_admin/class/bloc/class_management_bloc.dart';
import 'domain/usecases/class/get_all_classes_usecase.dart';
import 'domain/usecases/class/create_class_usecase.dart';
import 'domain/usecases/class/update_class_usecase.dart';
import 'domain/usecases/class/delete_class_usecase.dart';
import 'domain/usecases/class/get_class_by_id_usecase.dart';
import 'presentation/common/grade_select/cubit/grade_select_cubit.dart';

// Service Locator
final sl = GetIt.instance;

Future<void> init() async {
  // ! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      registerUserUseCase: sl(),
    ),
  );

  sl.registerFactory(() => SchoolBloc(getSchoolsByLevelUseCase: sl()));

  sl.registerFactory(() => ClassBloc(getClassesBySchoolUseCase: sl()));

  sl.registerFactory(() => GradeSelectCubit(getAllGradesUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => GetSchoolsByLevelUseCase(sl()));
  sl.registerLazySingleton(() => GetClassesBySchoolUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RoleRepository>(
    () => RoleRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SchoolRepository>(
    () => SchoolRepositoryImpl(schoolRemoteDataSource: sl()),
  );
  sl.registerLazySingleton<ClassRepository>(
    () => ClassRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<RoleRemoteDataSource>(
    () => RoleRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SchoolRemoteDataSource>(
    () => SchoolRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ClassRemoteDataSource>(
    () => ClassRemoteDataSourceImpl(sl()),
  );

  // ! Features - School Admin
  sl.registerLazySingleton<SchoolAdminRemoteDataSource>(
    () => SchoolAdminRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SchoolAdminRepository>(
    () => SchoolAdminRepositoryImpl(remoteDataSource: sl()),
  );

  // School Admin Features
  sl.registerFactory(
    () => school_admin.SchoolAdminSchoolBloc(
      getSchoolDetailUseCase: sl(),
      createSchoolUseCase: sl(),
      updateSchoolUseCase: sl(),
      deleteSchoolUseCase: sl(),
      authBloc: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetSchoolDetailForSchoolAdminUseCase(sl()));
  sl.registerLazySingleton(() => CreateSchoolUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSchoolUseCase(sl()));
  sl.registerLazySingleton(() => DeleteSchoolUseCase(sl()));

  // ! Features - Grade
  // Bloc
  sl.registerFactory(
    () => GradeManagementBloc(
      getAllGradesUseCase: sl(),
      createGradeUseCase: sl(),
      updateGradeUseCase: sl(),
      deleteGradeUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllGradesUseCase(sl()));
  sl.registerLazySingleton(() => CreateGradeUseCase(sl()));
  sl.registerLazySingleton(() => UpdateGradeUseCase(sl()));
  sl.registerLazySingleton(() => DeleteGradeUseCase(sl()));

  // ! Features - Class Management
  // Bloc
  sl.registerFactory(
    () => ClassManagementBloc(
      getAllClassUseCase: sl(),
      createClassUseCase: sl(),
      updateClassUseCase: sl(),
      deleteClassUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllClassesUseCase(sl()));
  sl.registerLazySingleton(() => CreateClassUseCase(sl()));
  sl.registerLazySingleton(() => UpdateClassUseCase(sl()));
  sl.registerLazySingleton(() => DeleteClassUseCase(sl()));
  sl.registerLazySingleton(() => GetClassByIdUseCase(sl()));

  // Repository
  sl.registerLazySingleton<GradeRepository>(
    () => GradeRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<GradeRemoteDataSource>(
    () => GradeRemoteDataSourceImpl(sl()),
  );

  // ! Core
  sl.registerLazySingleton(() => ApiClient(secureStorage: sl()));

  // ! External & Services
  sl.registerLazySingleton(() => SecureStorageService());
}
