import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/injection_container.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/bloc/class_member_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/bloc/class_member_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_member_dialog/class_member_dialog.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_bloc.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/common/class_selector/bloc/class_selector_event.dart';

Future<bool?> showClassMemberDialog({
  required BuildContext context,
  required String schoolId,
  String? teacherId,
  String? initialClassId,
  ClassMemberMode initialMode = ClassMemberMode.add,
  bool isTeacher = false,
}) async {
  final classMemberBloc = sl<ClassMemberBloc>();
  final classSelectorBloc = sl<ClassSelectorBloc>();

  // ✅ Dispatch event khởi tạo phù hợp với role
  if (isTeacher && teacherId != null) {
    classSelectorBloc.add(LoadClassesByTeacher(teacherId));
  } else {
    classSelectorBloc.add(LoadClassesBySchool(schoolId));
  }

  // ✅ Load students ban đầu nếu có classId
  classMemberBloc.add(
    LoadStudents(mode: initialMode, currentClassId: initialClassId),
  );

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => MultiBlocProvider(
      providers: [
        BlocProvider<ClassMemberBloc>.value(value: classMemberBloc),
        BlocProvider<ClassSelectorBloc>.value(value: classSelectorBloc),
      ],
      child: ClassMemberDialog(
        initialClassId: initialClassId,
        schoolId: schoolId,
        isTeacher: isTeacher,
      ),
    ),
  );

  await classMemberBloc.close();
  await classSelectorBloc.close();

  return result;
}
