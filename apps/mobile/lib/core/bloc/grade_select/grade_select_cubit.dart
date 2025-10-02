import 'package:flutter_bloc/flutter_bloc.dart';
import 'grade_select_state.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/grade/get_grades_for_select_usecase.dart';

class GradeSelectCubit extends Cubit<GradeSelectState> {
  final GetGradesForSelectUseCase _getGradesForSelectUseCase;

  GradeSelectCubit(this._getGradesForSelectUseCase)
    : super(GradeSelectInitial());

  Future<void> loadGrades() async {
    try {
      emit(GradeSelectLoading());
      final grades = await _getGradesForSelectUseCase.call();
      emit(GradeSelectSuccess(grades));
    } catch (e) {
      emit(GradeSelectError(e.toString()));
    }
  }
}
