import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/widgets/common/app_scaffold.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(body: Center(child: Text('Welcome, Teacher!')));
  }
}
