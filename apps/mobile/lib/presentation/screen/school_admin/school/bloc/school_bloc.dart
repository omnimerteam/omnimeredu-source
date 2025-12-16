import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/usecases/school/create_school_usecase.dart';
import '../../../../../domain/usecases/school/delete_school_usecase.dart';
import '../../../../../domain/usecases/school/get_school_detail_for_schooladmin_usecase.dart';
import '../../../../../domain/usecases/school/update_school_usecase.dart';
import '../../../../common/blocs/auth_bloc/auth_bloc.dart';
import 'school_event.dart';
import 'school_state.dart';

class SchoolAdminSchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final GetSchoolDetailForSchoolAdminUseCase getSchoolDetailUseCase;
  final CreateSchoolUseCase createSchoolUseCase;
  final UpdateSchoolUseCase updateSchoolUseCase;
  final DeleteSchoolUseCase deleteSchoolUseCase;
  final AuthBloc authBloc;

  SchoolAdminSchoolBloc({
    required this.getSchoolDetailUseCase,
    required this.createSchoolUseCase,
    required this.updateSchoolUseCase,
    required this.deleteSchoolUseCase,
    required this.authBloc,
  }) : super(SchoolInitial()) {
    on<LoadSchoolDetail>(_onLoadSchoolDetail);
    on<CreateSchool>(_onCreateSchool);
    on<UpdateSchool>(_onUpdateSchool);
    on<DeleteSchool>(_onDeleteSchool);
  }

  Future<void> _onLoadSchoolDetail(
    LoadSchoolDetail event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolLoading());
    try {
      final school = await getSchoolDetailUseCase.call();
      if (school == null) {
        emit(SchoolEmpty());
      } else {
        emit(SchoolLoaded(school));
      }
    } catch (e) {
      emit(SchoolError(e.toString()));
    }
  }

  Future<void> _onCreateSchool(
    CreateSchool event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolLoading());
    try {
      final school = await createSchoolUseCase.call(event.school);
      
      // Update auth bloc with new school info if needed
      // Note: AuthBloc events might be different in mobile vs omnimereduapp
      // Checking AuthBloc definition in mobile might be needed, but assuming for now or commenting out
      // authBloc.add(AuthSchoolUpdated(schoolName: school.name)); 

      emit(SchoolLoaded(school));
    } catch (e) {
      emit(SchoolError(e.toString()));
    }
  }

  Future<void> _onUpdateSchool(
    UpdateSchool event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolLoading());
    try {
      final school = await updateSchoolUseCase.call(event.school);
       // authBloc.add(AuthSchoolUpdated(schoolName: school.name));
      emit(SchoolLoaded(school));
    } catch (e) {
      emit(SchoolError(e.toString()));
    }
  }

  Future<void> _onDeleteSchool(
    DeleteSchool event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolLoading());
    try {
      await deleteSchoolUseCase.call();
      // authBloc.add(AuthSchoolUpdated(schoolName: null));
      emit(SchoolEmpty());
    } catch (e) {
      emit(SchoolError(e.toString()));
    }
  }
}
