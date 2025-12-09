import 'package:get_it/get_it.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';

// Service Locator
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  // sl.registerFactory(() => AuthenticationBloc(userRepository: sl()));
  // sl.registerFactory(() => LoginCubit(loginUseCase: sl()));

  // Use cases
  // sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  // sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()));

  //! Core
  // Network
  // sl.registerLazySingleton(() => Dio());

  //! External
  // final sharedPreferences = await SharedPreferences.getInstance();
  // sl.registerLazySingleton(() => sharedPreferences);

  // TODO: Add dependency injection setup here
  // 1. External (SharedPreferences, libraries)
  // 2. Core (Network, styles, utilities)
  // 3. Data sources
  // 4. Repositories
  // 5. Use cases
  // 6. Blocs / Cubits
}
