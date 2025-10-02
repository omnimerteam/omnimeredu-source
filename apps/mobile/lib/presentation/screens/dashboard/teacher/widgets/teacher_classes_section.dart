import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/domain/entities/teaching_assignment/class_teacher_assign_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/teacher/cubit/teacher_classes_state.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/teacher/widgets/teacher_classes_header.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/teacher/widgets/teacher_classes_loading.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/teacher/widgets/teacher_classes_empty.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/teacher/widgets/teacher_classes_list.dart';

class TeacherClassesSection extends StatelessWidget {
  final bool isLoading;
  final TeacherClassesState state;
  final List<ClassTeacherAssignEntity> classes;
  final void Function(ClassTeacherAssignEntity) onInitializeAttendance;
  final void Function(ClassTeacherAssignEntity) onViewAttendance;
  final void Function(ClassTeacherAssignEntity) onViewStudents;

  const TeacherClassesSection({
    Key? key,
    required this.isLoading,
    required this.state,
    required this.classes,
    required this.onInitializeAttendance,
    required this.onViewAttendance,
    required this.onViewStudents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoadingState = isLoading || state is InitializingAttendance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TeacherClassesHeader(total: classes.length, isLoading: isLoadingState),
        const SizedBox(height: 16),
        if (isLoadingState)
          const TeacherClassesLoading()
        else if (classes.isEmpty)
          const TeacherClassesEmpty()
        else
          TeacherClassesList(
            classes: classes,
            onInitializeAttendance: onInitializeAttendance,
            onViewAttendance: onViewAttendance,
            onViewStudents: onViewStudents,
          ),
      ],
    );
  }
}
