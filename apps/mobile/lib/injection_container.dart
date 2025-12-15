import 'package:get_it/get_it.dart';

import 'core/api/api_client.dart';
import 'services/secure_storage_service.dart';

import 'data/datasources/remote/auth/auth_remote_data_source.dart';
import 'data/datasources/remote/auth/role_remote_datasource.dart';
import 'data/datasources/remote/school/school_remote_data_source.dart';
import 'data/datasources/remote/school/class_remote_data_source.dart';

import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/role_repository.dart';
import 'domain/repositories/school_repository.dart';
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

  // ! Core
  sl.registerLazySingleton(() => ApiClient(secureStorage: sl()));

  // ! External & Services
  sl.registerLazySingleton(() => SecureStorageService());
}
