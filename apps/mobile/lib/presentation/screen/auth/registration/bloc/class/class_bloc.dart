import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/domain/entities/class/class_selector_entity.dart';
import '../../../../../../domain/usecases/school/search_classes_by_school_usecase.dart';
import 'class_event.dart';
import 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final SearchClassesBySchoolUseCase searchClassesBySchoolUseCase;

  // Cache to store all classes for the current school
  List<ClassSelectorEntity> _allClasses = [];
  String _currentSchoolId = "";

  ClassBloc({required this.searchClassesBySchoolUseCase})
    : super(ClassInitial()) {
    on<LoadClassesBySchool>(_onLoadClasses);
  }

  Future<void> _onLoadClasses(
    LoadClassesBySchool event,
    Emitter<ClassState> emit,
  ) async {
    // If we're searching for a new school, or we have no data yet
    if (event.schoolId != _currentSchoolId || _allClasses.isEmpty) {
      emit(ClassLoading());
      final result = await searchClassesBySchoolUseCase.call(event.schoolId);

      result.fold((error) => emit(ClassError("Không có lớp phù hợp")), (
        classes,
      ) {
        if (classes.isEmpty) {
          emit(ClassError("Không có lớp phù hợp"));
          _allClasses = [];
          _currentSchoolId = "";
        } else {
          _allClasses = classes;
          _currentSchoolId = event.schoolId;
          _filterAndEmit(event.grade, emit);
        }
      });
    } else {
      // Reuse cached data
      _filterAndEmit(event.grade, emit);
    }
  }

  void _filterAndEmit(String? grade, Emitter<ClassState> emit) {
    // Filter by grade if provided in event
    final filteredClasses = _allClasses.where((e) {
      if (grade == null || grade.isEmpty) return true;
      return e.gradeGroup.name == grade;
    }).toList();

    if (filteredClasses.isEmpty) {
      emit(ClassError("Không có lớp phù hợp"));
    } else {
      emit(ClassLoaded(classes: filteredClasses));
    }
  }
}
