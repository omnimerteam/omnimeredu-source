import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/domain/entities/query/default_query_entity.dart';
import 'package:mobile/domain/usecases/grade/get_all_grades_usecase.dart';
import 'grade_select_state.dart';

class GradeSelectCubit extends Cubit<GradeSelectState> {
  final GetAllGradesUseCase _getAllGradesUseCase;

  GradeSelectCubit({required GetAllGradesUseCase getAllGradesUseCase})
    : _getAllGradesUseCase = getAllGradesUseCase,
      super(GradeSelectInitial());

  Future<void> loadGrades() async {
    try {
      emit(GradeSelectLoading());
      // Calling with default query or appropriate params
      // Reference used GetGradesForSelectUseCase which implies no special filtering
      final result = await _getAllGradesUseCase(
        DefaultQueryEntity(limit: 100),
      ); // Ensure we get enough

      result.fold(
        (failure) => emit(GradeSelectError(failure.message)),
        (grades) => emit(GradeSelectSuccess(grades)),
      );
    } catch (e) {
      emit(GradeSelectError(e.toString()));
    }
  }
}
