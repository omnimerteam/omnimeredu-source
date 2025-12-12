import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_view.dart';

// TODO: Import AuthenticationBloc & ThemeCubit khi đã tạo
// import 'package:mobile/presentation/common/cubits/theme_cubit.dart';
// import 'package:mobile/presentation/common/blocs/auth/authentication_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Pixel 9 Pro specifications: 427x952 dp
      designSize: const Size(427, 952),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // TODO: Uncomment MultiBlocProvider khi đã có AuthBloc và ThemeCubit
        /*
        return MultiBlocProvider(
          providers: [
            // Authentication Bloc - global
            BlocProvider(
              create: (_) =>
                  sl<AuthenticationBloc>()..add(AuthenticationStarted()),
            ),
            // Theme Cubit - global
            BlocProvider(create: (_) => sl<ThemeCubit>()),
          ],
          child: const AppView(),
        );
        */

        // Tạm thời trả về AppView trực tiếp
        return const AppView();
      },
    );
  }
}
