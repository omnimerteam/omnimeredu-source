import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../domain/usecases/school/get_classes_by_school_usecase.dart';
import 'class_event.dart';
import 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final GetClassesBySchoolUseCase getClassesBySchoolUseCase;

  ClassBloc({required this.getClassesBySchoolUseCase}) : super(ClassInitial()) {
    on<LoadClassesBySchool>(_onLoadClasses);
  }

  Future<void> _onLoadClasses(
    LoadClassesBySchool event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());

    final result = await getClassesBySchoolUseCase.call(
      GetClassesBySchoolParams(schoolId: event.schoolId, grade: event.grade),
    );

    result.fold((error) => emit(ClassError("Không có lớp phù hợp")), (classes) {
      if (classes.isEmpty) {
        emit(ClassError("Không có lớp phù hợp"));
      } else {
        emit(ClassLoaded(classes: classes));
      }
    });
  }
}
