import 'package:firebase_auth/firebase_auth.dart';

import 'package:get_it/get_it.dart';

import 'core/network/api_client.dart';

// DataSources
import 'data/datasources/remote/auth_remote_data_source.dart';
import 'data/datasources/remote/role_remote_datasource.dart';

// Repositories
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/role_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/role_repository.dart';

// UseCases
import 'domain/usecases/register_user_usecase.dart';
import 'domain/usecases/get_all_roles_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/login_usecase.dart';

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

  // ======================
  // DataSources
  // ======================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl(), sl()),
  );
  sl.registerLazySingleton<RoleRemoteDataSource>(
    () => RoleRemoteDataSource(sl()),
  );

  // ======================
  // Repositories
  // ======================
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<RoleRepository>(() => RoleRepositoryImpl(sl()));

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

  // ======================
  // Blocs
  // ======================
  sl.registerFactory(
    () => RegistrationBloc(
      registerUserUseCase: sl(),
      uploader: sl(),
      getAllRolesUseCase: sl(),
    ),
  );

  sl.registerFactory(() => LoginBloc(loginUseCase: sl()));
}
