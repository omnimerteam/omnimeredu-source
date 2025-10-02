import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/get_all_classes_in_school_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/teaching_assignment/get_classes_teacher_assign_by_teacher_id_usecase.dart';

import 'class_selector_event.dart';
import 'class_selector_state.dart';

class ClassSelectorBloc extends Bloc<ClassSelectorEvent, ClassSelectorState> {
  final GetAllClassesInSchoolUseCase getClassesBySchoolUseCase;
  final GetClassesTeacherAssignByTeacherIdUseCase getClassesByTeacherUseCase;

  ClassSelectorBloc({
    required this.getClassesBySchoolUseCase,
    required this.getClassesByTeacherUseCase,
  }) : super(ClassSelectorInitial()) {
    on<LoadClassesBySchool>(_onLoadClassesBySchool);
    on<LoadClassesByTeacher>(_onLoadClassesByTeacher);
  }

  Future<void> _onLoadClassesBySchool(
    LoadClassesBySchool event,
    Emitter<ClassSelectorState> emit,
  ) async {
    emit(ClassSelectorLoading());
    try {
      final classes = await getClassesBySchoolUseCase.call(event.schoolId);
      emit(ClassSelectorLoaded(classes: classes));
    } catch (e) {
      emit(const ClassSelectorError("Lỗi tải danh sách lớp theo trường"));
    }
  }

  Future<void> _onLoadClassesByTeacher(
    LoadClassesByTeacher event,
    Emitter<ClassSelectorState> emit,
  ) async {
    emit(ClassSelectorLoading());
    try {
      final response = await getClassesByTeacherUseCase
          .getClassesTeacherAssignByTeacherId(event.teacherId);

      if (response.success && response.data != null) {
        emit(ClassSelectorLoaded(classes: response.data!));
      } else {
        emit(
          ClassSelectorError(
            response.message ?? "Không thể tải danh sách lớp theo giáo viên",
          ),
        );
      }
    } catch (e) {
      emit(const ClassSelectorError("Lỗi tải danh sách lớp theo giáo viên"));
    }
  }
}
