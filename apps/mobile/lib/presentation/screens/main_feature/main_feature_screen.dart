import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/auth_user_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/no_access_screen.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_feature/teacher/bloc/teacher_attendance_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_feature/teacher/bloc/teacher_attendance_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/main_feature/teacher/teacher_main_screen.dart';

class MainFeatureScreen extends StatefulWidget {
  final AuthUserEntity user;
  final String? classId;

  const MainFeatureScreen({super.key, required this.user, this.classId});

  @override
  State<MainFeatureScreen> createState() => MainFeatureScreenState();
}

class MainFeatureScreenState extends State<MainFeatureScreen> {
  String? _currentClassId;

  @override
  void initState() {
    super.initState();
    _currentClassId = widget.classId;
  }

  @override
  void didUpdateWidget(covariant MainFeatureScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Nếu classId từ ngoài truyền vào thay đổi
    if (widget.classId != null && widget.classId != _currentClassId) {
      _currentClassId = widget.classId;
      _loadAttendance(_currentClassId!, DateTime.now());
    }
  }

  void _loadAttendance(String classId, DateTime date) {
    context.read<TeacherAttendanceBloc>().add(
      LoadAttendanceRecord(classId: classId, date: date),
    );
  }

  void loadAttendance(String classId, DateTime date) {
    // Hàm public cho MainScreen gọi trực tiếp
    _currentClassId = classId;
    _loadAttendance(classId, date);
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.user.roleName;

    switch (role) {
      case 'Teacher':
        final schoolId = widget.user.schoolId;
        if (schoolId == null) return const NoAccessScreen();

        return BlocListener<ClassSelectorBloc, ClassSelectorState>(
          listenWhen: (previous, current) =>
              current is ClassSelectorLoaded && current.classes.isNotEmpty,
          listener: (context, state) {
            if (state is ClassSelectorLoaded && state.classes.isNotEmpty) {
              // Nếu chưa có classId nào thì chọn mặc định class đầu tiên
              _currentClassId ??= state.classes.first.id;
              _loadAttendance(_currentClassId!, DateTime.now());
            }
          },
          child: TeacherAttendanceScreen(schoolId: schoolId),
        );

      case 'SchoolAdmin':
        return const NoAccessScreen();

      case 'Student':
        return const NoAccessScreen();

      default:
        return const NoAccessScreen();
    }
  }
}
