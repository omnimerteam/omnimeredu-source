import 'package:get_it/get_it.dart';

import 'core/api/api_client.dart';
import 'services/secure_storage_service.dart';

import 'data/datasources/remote/auth/auth_remote_data_source.dart';
import 'data/datasources/remote/auth/role_remote_datasource.dart';

import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/role_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/role_repository_impl.dart';

import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/logout_usecase.dart';
import 'domain/usecases/auth/get_current_user_usecase.dart';

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
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RoleRepository>(
    () => RoleRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<RoleRemoteDataSource>(
    () => RoleRemoteDataSourceImpl(sl()),
  );

  // ! Core
  sl.registerLazySingleton(() => ApiClient(secureStorage: sl()));

  // ! External & Services
  sl.registerLazySingleton(() => SecureStorageService());
}
