import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/enum_constant.dart';
import '../../../../../../domain/usecases/school/get_schools_by_level_usecase.dart';
import '../../../../../../domain/entities/school/school_search_entity.dart';
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

    try {
      final result = await getSchoolsByLevelUseCase.call(
        educationLevel: event.level.name,
      );

      final schools = result.fold(
        (error) => throw Exception(error.message),
        (schools) => schools,
      );

      // Convert to SchoolSearchEntity
      final schoolSearchEntities = schools.map((school) => SchoolSearchEntity(
        id: school.id,
        name: school.name,
        code: school.code,
        address: school.address,
      )).toList();

      if (schoolSearchEntities.isEmpty) {
        emit(SchoolError("Không có trường phù hợp"));
      } else {
        emit(SchoolLoaded(schools: schoolSearchEntities));
      }
    } catch (e) {
      emit(SchoolError("Không có trường phù hợp"));
    }
  }
}
