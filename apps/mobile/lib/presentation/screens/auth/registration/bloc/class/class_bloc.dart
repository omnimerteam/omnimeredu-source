import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/get_all_classes_in_school_usecase.dart';
import 'class_event.dart';
import 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final GetAllClassesInSchoolUseCase getClassesBySchoolUseCase;

  ClassBloc({required this.getClassesBySchoolUseCase}) : super(ClassInitial()) {
    on<LoadClassesBySchool>(_onLoadClassesBySchool);
  }

  Future<void> _onLoadClassesBySchool(
    LoadClassesBySchool event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());
    try {
      // await để lấy data từ usecase
      final classes = await getClassesBySchoolUseCase.call(event.schoolId);

      if (classes.isEmpty) {
        emit(ClassError("Không có lớp phù hợp"));
      } else {
        emit(ClassLoaded(classes: classes));
      }
    } catch (e) {
      emit(ClassError("Lỗi tải danh sách"));
    }
  }
}
