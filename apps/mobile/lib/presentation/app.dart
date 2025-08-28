import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/registration_bloc.dart';

import '../../domain/usecases/register_user.dart';
import '../../services/firebase_storage_uploader.dart';
import 'app_view.dart';

class App extends StatelessWidget {
  final RegisterUserUseCase usecase;
  final FirebaseStorageUploader uploader;

  const App({super.key, required this.usecase, required this.uploader});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              RegistrationBloc(registerUser: usecase, uploader: uploader),
        ),
      ],
      child: const AppView(),
    );
  }
}
