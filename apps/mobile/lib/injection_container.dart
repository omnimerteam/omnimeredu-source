import 'package:get_it/get_it.dart';
import 'package:mobile/domain/repositories/school/school_repository.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/services/secure_storage_service.dart';

import 'package:mobile/data/datasources/remote/auth/auth_remote_data_source.dart';
import 'package:mobile/data/datasources/remote/auth/role_remote_datasource.dart';
import 'package:mobile/data/datasources/remote/school/school_remote_data_source.dart';
import 'package:mobile/data/datasources/remote/school/class_remote_data_source.dart';

import 'package:mobile/domain/repositories/auth/auth_repository.dart';
import 'package:mobile/domain/repositories/auth/role_repository.dart';
import 'package:mobile/data/repositories/auth/auth_repository_impl.dart';
import 'package:mobile/data/repositories/auth/role_repository_impl.dart';
import 'package:mobile/data/repositories/school/school_repository_impl.dart';
import 'package:mobile/data/datasources/remote/user/school_admin_remote_data_source.dart';
import 'package:mobile/data/repositories/user/school_admin_repository_impl.dart';
import 'package:mobile/domain/repositories/school/class_repository.dart';
import 'package:mobile/data/repositories/school/class_repository_impl.dart';

import 'package:mobile/domain/repositories/user/school_admin_repository.dart';

import 'package:mobile/domain/usecases/auth/login_usecase.dart';
import 'package:mobile/domain/usecases/auth/logout_usecase.dart';
import 'package:mobile/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:mobile/domain/usecases/auth/register_user_usecase.dart';
import 'package:mobile/domain/usecases/school/get_schools_by_level_usecase.dart';
import 'package:mobile/domain/usecases/school/get_classes_by_school_usecase.dart';
import 'package:mobile/domain/usecases/school/search_classes_by_school_usecase.dart';

import 'package:mobile/presentation/common/blocs/auth_bloc/auth_bloc.dart';
import 'package:mobile/presentation/screen/auth/registration/bloc/school/school_bloc.dart';
import 'package:mobile/presentation/screen/auth/registration/bloc/class/class_bloc.dart';
import 'package:mobile/presentation/screen/school_admin/school/bloc/school_bloc.dart'
    as school_admin; // Alias to avoid conflict if any, but class names are different now.
import 'package:mobile/domain/usecases/school/get_school_detail_for_schooladmin_usecase.dart';
import 'package:mobile/domain/usecases/school/create_school_usecase.dart';
import 'package:mobile/domain/usecases/school/update_school_usecase.dart';
import 'package:mobile/domain/usecases/school/delete_school_usecase.dart';

import 'package:mobile/data/datasources/remote/school/grade_remote_data_source.dart';
import 'package:mobile/domain/repositories/school/grade_repository.dart';
import 'package:mobile/data/repositories/school/grade_repository_impl.dart';
import 'package:mobile/domain/usecases/grade/get_all_grades_usecase.dart';
import 'package:mobile/domain/usecases/grade/create_grade_usecase.dart';
import 'package:mobile/domain/usecases/grade/update_grade_usecase.dart';
import 'package:mobile/domain/usecases/grade/delete_grade_usecase.dart';
import 'package:mobile/presentation/screen/school_admin/grade/bloc/grade_management_bloc.dart';
import 'package:mobile/presentation/screen/school_admin/class/bloc/class_management_bloc.dart';
import 'package:mobile/domain/usecases/class/get_all_classes_usecase.dart';
import 'package:mobile/domain/usecases/class/create_class_usecase.dart';
import 'package:mobile/domain/usecases/class/update_class_usecase.dart';
import 'package:mobile/domain/usecases/class/delete_class_usecase.dart';
import 'package:mobile/domain/usecases/class/get_class_by_id_usecase.dart';
import 'package:mobile/presentation/common/grade_select/cubit/grade_select_cubit.dart';

import 'package:mobile/data/datasources/remote/school/membership_request_remote_datasource.dart';
import 'package:mobile/data/repositories/school/membership_request_repository_impl.dart';
import 'package:mobile/domain/repositories/school/membership_request_repository.dart';
import 'package:mobile/domain/usecases/membership_request/get_all_membership_requests_usecase.dart';
import 'package:mobile/domain/usecases/membership_request/create_membership_request_usecase.dart';
import 'package:mobile/domain/usecases/membership_request/update_membership_request_usecase.dart';
import 'package:mobile/domain/usecases/membership_request/delete_membership_request_usecase.dart';
import 'package:mobile/domain/usecases/membership_request/get_membership_request_by_id_usecase.dart';
import 'package:mobile/domain/usecases/membership_request/update_status_membership_request_usecase.dart';
import 'package:mobile/presentation/screen/school_admin/membership_request/bloc/membership_request_bloc.dart';

// Student QR Attendance
import 'package:mobile/presentation/screen/student/attendance/bloc/qr_scanner_bloc.dart';
import 'package:mobile/domain/usecases/qr_attendance/submit_attendance_usecase.dart';
import 'package:mobile/domain/usecases/qr_attendance/sync_offline_scans_usecase.dart';
import 'package:mobile/domain/repositories/attendance/qr_attendance_repository.dart';
import 'package:mobile/data/repositories/attendance/qr_attendance_repository_impl.dart';
import 'package:mobile/data/datasources/remote/attendance/qr_attendance_remote_datasource.dart';
import 'package:mobile/services/qr_service/connectivity_service.dart';
import 'package:mobile/services/qr_service/location_service.dart';
import 'package:mobile/services/qr_service/offline_queue_service.dart';

// Teacher Attendance
import 'package:mobile/presentation/screen/teacher/home/bloc/teacher_attendance_bloc.dart';
import 'package:mobile/presentation/screen/teacher/qr/bloc/qr_display_bloc.dart';
import 'package:mobile/domain/usecases/qr_attendance/generate_qr_code_usecase.dart';
import 'package:mobile/domain/usecases/attendance/get_class_attendance_record_view_usecase.dart';
import 'package:mobile/domain/usecases/attendance/initialize_class_attendancee_usecase.dart';
import 'package:mobile/domain/usecases/attendance/delete_attendance_usecase.dart';
import 'package:mobile/domain/repositories/attendance/attendance_repository.dart';
import 'package:mobile/data/repositories/attendance/attendance_repository_impl.dart';
import 'package:mobile/data/datasources/remote/attendance/attendance_remote_data_source.dart';

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

  sl.registerFactory(() => ClassBloc(searchClassesBySchoolUseCase: sl()));

  sl.registerFactory(() => GradeSelectCubit(getAllGradesUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => GetSchoolsByLevelUseCase(sl()));
  sl.registerLazySingleton(() => GetClassesBySchoolUseCase(sl()));
  sl.registerLazySingleton(() => SearchClassesBySchoolUseCase(sl()));

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

  // ! Features - Membership Request
  // Bloc
  sl.registerFactory(
    () => MembershipRequestBloc(
      getAllMembershipRequests: sl(),
      updateStatusMembershipRequest: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllMembershipRequestsUseCase(sl()));
  sl.registerLazySingleton(() => CreateMembershipRequestUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMembershipRequestUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMembershipRequestUseCase(sl()));
  sl.registerLazySingleton(() => GetMembershipRequestByIdUseCase(sl()));
  sl.registerLazySingleton(() => UpdateStatusMembershipRequestUseCase(sl()));

  // Repository
  sl.registerLazySingleton<MembershipRequestRepository>(
    () => MembershipRequestRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MembershipRequestRemoteDataSource>(
    () => MembershipRequestRemoteDataSource(sl()),
  );

  // ! Features - Student Attendance
  // Bloc
  sl.registerFactory(
    () => QRScannerBloc(
      sl(), // SubmitAttendanceUseCase
      sl(), // SyncOfflineScansUseCase
      sl(), // ConnectivityService
      sl(), // LocationService
    ),
  );

  // Use cases
  sl.registerLazySingleton(
    () => SubmitAttendanceUseCase(sl(), sl(), sl(), sl()),
  );
  sl.registerLazySingleton(() => SyncOfflineScansUseCase(sl(), sl(), sl()));

  // Repository
  sl.registerLazySingleton<QRAttendanceRepository>(
    () => QRAttendanceRepositoryImpl(sl(), sl()),
  );

  // Data sources
  sl.registerLazySingleton<QRAttendanceRemoteDatasource>(
    () => QRAttendanceRemoteDatasource(sl()),
  );

  // ! Features - Teacher Attendance
  // Bloc
  sl.registerFactory(
    () => TeacherAttendanceBloc(
      getAttendanceRecord: sl(),
      initializeAttendance: sl(),
      deleteAttendance: sl(),
      searchClasses: sl(),
    ),
  );
  sl.registerFactory(() => QRDisplayBloc(generateQRCode: sl()));

  // Use cases
  sl.registerLazySingleton(() => GenerateQRCodeUseCase(sl()));
  sl.registerLazySingleton(() => GetClassAttendanceRecordViewUseCase(sl()));
  sl.registerLazySingleton(() => InitializeClassAttendanceUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAttendanceUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton(() => AttendanceRemoteDataSource(sl()));

  // Services
  sl.registerLazySingleton(() => ConnectivityService());
  sl.registerLazySingleton(() => LocationService());
  sl.registerLazySingleton(() => OfflineQueueService());

  // ! Core
  sl.registerLazySingleton(() => ApiClient(secureStorage: sl()));

  // ! External & Services
  sl.registerLazySingleton(() => SecureStorageService());
}
