import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/get_class_detail_view_by_id.dart';
import 'class_detail_state.dart';

class ClassDetailCubit extends Cubit<ClassDetailState> {
  final GetClassDetailViewByIdUseCase getClassDetailViewByIdUseCase;

  ClassDetailCubit({required this.getClassDetailViewByIdUseCase})
    : super(ClassDetailInitial());

  Future<void> loadClassDetail(String classId) async {
    try {
      emit(ClassDetailLoading());
      final classDetail = await getClassDetailViewByIdUseCase.call(classId);
      emit(
        ClassDetailLoaded(
          classDetail: classDetail,
          filteredStudents: classDetail.students ?? [],
        ),
      );
    } catch (e) {
      emit(ClassDetailError(e.toString()));
    }
  }

  void searchStudents(String query) {
    if (state is ClassDetailLoaded) {
      final currentState = state as ClassDetailLoaded;
      final allStudents = currentState.classDetail.students ?? [];

      if (query.isEmpty) {
        emit(
          currentState.copyWith(
            filteredStudents: allStudents,
            searchQuery: query,
          ),
        );
      } else {
        final filtered = allStudents.where((student) {
          return student.fullName.toLowerCase().contains(query.toLowerCase()) ||
              (student.phone?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (student.guardianName?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ??
                  false);
        }).toList();

        emit(
          currentState.copyWith(filteredStudents: filtered, searchQuery: query),
        );
      }
    }
  }

  Future<void> refreshClassDetail() async {
    if (state is ClassDetailLoaded) {
      final currentState = state as ClassDetailLoaded;
      await loadClassDetail(currentState.classDetail.id);
    }
  }
}
