import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile/domain/usecases/school/get_schools_by_level_usecase.dart';
import 'school_event.dart';
import 'school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final GetSchoolsByLevelUseCase getSchoolsByLevelUseCase;
  SchoolBloc({required this.getSchoolsByLevelUseCase})
    : super(SchoolInitial()) {
    on<LoadSchoolsByLevel>(_onLoadSchools);
  }

  Future<void> _onLoadSchools(
    LoadSchoolsByLevel event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolLoading());

    final result = await getSchoolsByLevelUseCase.call(
      GetSchoolsByLevelParams(educationLevel: event.level),
    );

    result.fold((error) => emit(SchoolError("Không có trường phù hợp")), (
      schools,
    ) {
      if (schools.isEmpty) {
        emit(SchoolError("Không có trường phù hợp"));
      } else {
        emit(SchoolLoaded(schools: schools));
      }
    });
  }
}
