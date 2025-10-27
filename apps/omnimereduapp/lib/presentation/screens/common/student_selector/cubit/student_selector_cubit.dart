import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/usecases/student/get_student_selector_usecase.dart';
import 'student_selector_state.dart';

class StudentSelectorCubit extends Cubit<StudentSelectorState> {
  final GetStudentSelectorUseCase _getStudentSelectorUseCase;

  StudentSelectorCubit(this._getStudentSelectorUseCase)
    : super(StudentSelectorInitial());

  Future<void> loadStudents() async {
    try {
      emit(StudentSelectorLoading());
      final response = await _getStudentSelectorUseCase.call(null);
      if (response.success && response.data != null) {
        emit(StudentSelectorSuccess(response.data!));
      } else {
        emit(
          StudentSelectorError(
            response.message ?? 'Không thể tải danh sách học sinh',
          ),
        );
      }
    } catch (e) {
      emit(StudentSelectorError(e.toString()));
    }
  }
}
