import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_bloc.dart';
import 'package:flutter_ios_android_platforms/core/bloc/authentication/authentication_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/class/class_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/registration/bloc/class/class_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/auth/role/bloc/role_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/personnel/bloc/personnel_management_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/personnel/bloc/personnel_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/personnel/personnel_management_screen.dart';

class PersonnelManagementPage extends StatefulWidget {
  const PersonnelManagementPage({super.key});

  @override
  State<PersonnelManagementPage> createState() =>
      _PersonnelManagementPageState();
}

class _PersonnelManagementPageState extends State<PersonnelManagementPage> {
  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthenticationBloc>().state;
    if (authState is AuthenticationAuthenticated) {
      // Load personnel data
      context.read<PersonnelManagementBloc>().add(LoadPersonnelEvent());

      // Load classes for the school
      if (authState.user.schoolId != null) {
        context.read<ClassBloc>().add(
          LoadClassesBySchool(authState.user.schoolId!),
        );
      }

      // Load roles for personnel
      context.read<RoleBloc>().add(FetchRolePersonnelEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const PersonnelManagementScreen();
  }
}
