import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/usecases/school/create_school_usecase.dart';
import '../../../../../domain/usecases/school/delete_school_usecase.dart';
import '../../../../../domain/usecases/school/get_school_detail_for_schooladmin_usecase.dart';
import '../../../../../domain/usecases/school/update_school_usecase.dart';
import '../../../../common/blocs/auth_bloc/auth_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
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
    final result = await getSchoolDetailUseCase.call(NoParams());
    result.fold((failure) => emit(SchoolError(failure.message)), (school) {
      if (school == null) {
        emit(SchoolEmpty());
      } else {
        emit(SchoolLoaded(school));
      }
    });
  }

  Future<void> _onCreateSchool(
    CreateSchool event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolLoading());
    final result = await createSchoolUseCase.call(event.school);
    result.fold(
      (failure) => emit(SchoolError(failure.message)),
      (school) => emit(SchoolLoaded(school)),
    );
  }

  Future<void> _onUpdateSchool(
    UpdateSchool event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolLoading());
    final result = await updateSchoolUseCase.call(event.school);
    result.fold(
      (failure) => emit(SchoolError(failure.message)),
      (school) => emit(SchoolLoaded(school)),
    );
  }

  Future<void> _onDeleteSchool(
    DeleteSchool event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolLoading());
    final result = await deleteSchoolUseCase.call(NoParams());
    result.fold(
      (failure) => emit(SchoolError(failure.message)),
      (_) => emit(SchoolEmpty()),
    );
  }
}
