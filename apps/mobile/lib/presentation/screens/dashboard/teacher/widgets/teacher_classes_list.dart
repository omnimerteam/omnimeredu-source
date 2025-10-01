import 'package:flutter/material.dart';
import 'package:flutter_ios_android_platforms/domain/entities/teaching_assignment/class_teacher_assign_entity.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/dashboard/teacher/widgets/teacher_class_item.dart';

class TeacherClassesList extends StatelessWidget {
  final List<ClassTeacherAssignEntity> classes;
  final void Function(ClassTeacherAssignEntity) onInitializeAttendance;
  final void Function(ClassTeacherAssignEntity) onViewAttendance;
  final void Function(ClassTeacherAssignEntity) onViewStudents;

  const TeacherClassesList({
    Key? key,
    required this.classes,
    required this.onInitializeAttendance,
    required this.onViewAttendance,
    required this.onViewStudents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final assignment = classes[index];
        return TeacherClassItem(
          classAssignment: assignment,
          onInitializeAttendance: () => onInitializeAttendance(assignment),
          onViewAttendance: () => onViewAttendance(assignment),
          onViewStudents: () => onViewStudents(assignment),
        );
      },
    );
  }
}
