import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_ios_android_platforms/data/datasources/remote/role_remote_datasource.dart';
import 'package:flutter_ios_android_platforms/data/repositories/role_repository_impl.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/get_roles.dart';
import 'package:flutter_ios_android_platforms/presentation/app.dart';

import 'core/network/api_client.dart';
import 'data/datasources/remote/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/register_user.dart';
import 'services/firebase_storage_uploader.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase (nếu dùng FlutterFire CLI)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load biến môi trường
  await dotenv.load();

  // Khởi tạo dependencies
  final api = ApiClient();
  final remote = AuthRemoteDataSource(api);
  final repo = AuthRepositoryImpl(remote);
  final registerUserUseCase = RegisterUserUseCase(repo);
  final uploader = FirebaseStorageUploader();

  final remoteRole = RoleRemoteDataSource(api);
  final roleRepo = RoleRepositoryImpl(remoteRole);
  final getAllRolesUseCase = GetAllRolesUseCase(roleRepo);

  runApp(
    App(
      registerUserUseCase: registerUserUseCase,
      uploader: uploader,
      getAllRolesUseCase: getAllRolesUseCase,
    ),
  );
}
