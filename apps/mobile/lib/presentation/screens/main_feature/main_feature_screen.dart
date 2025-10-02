import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/injection_container.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/no_access_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_feature/teacher/bloc/teacher_attendance_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_feature/teacher/bloc/teacher_attendance_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_feature/teacher/teacher_main_screen.dart';

class MainFeatureScreen extends StatelessWidget {
  final dynamic user; // user có roleName

  const MainFeatureScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final role = user.roleName?.toLowerCase() ?? '';

    switch (role) {
      case 'teacher':
      case 'giáo viên':
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authState) {
            if (authState is AuthenticationAuthenticated) {
              final teacherId = authState.user.id;
              final schoolId = authState.user.schoolId;

              if (schoolId == null) {
                return NoAccessScreen();
              }

              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => sl<TeacherAttendanceBloc>()),
                  BlocProvider(
                    create: (_) {
                      final bloc = sl<ClassSelectorBloc>();
                      if (teacherId.isNotEmpty) {
                        bloc.add(LoadClassesByTeacher(teacherId));
                      }
                      return bloc;
                    },
                  ),
                ],
                child: BlocListener<ClassSelectorBloc, ClassSelectorState>(
                  listenWhen: (previous, current) =>
                      current is ClassSelectorLoaded &&
                      current.classes.isNotEmpty,
                  listener: (context, state) {
                    if (state is ClassSelectorLoaded &&
                        state.classes.isNotEmpty) {
                      final firstClassId = state.classes.first.id;
                      context.read<TeacherAttendanceBloc>().add(
                        LoadAttendanceRecord(
                          date: DateTime.now(),
                          classId: firstClassId,
                        ),
                      );
                    }
                  },
                  child: TeacherAttendanceScreen(schoolId: schoolId),
                ),
              );
            } else {
              return const NoAccessScreen();
            }
          },
        );

      default:
        return const NoAccessScreen();
    }
  }
}
