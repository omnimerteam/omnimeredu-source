import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/constants/app_constant.dart';
import 'package:mobile/domain/entities/query/default_query_entity.dart';
import 'package:mobile/domain/usecases/grade/create_grade_usecase.dart';
import 'package:mobile/domain/usecases/grade/delete_grade_usecase.dart';
import 'package:mobile/domain/usecases/grade/get_all_grades_usecase.dart';
import 'package:mobile/domain/usecases/grade/update_grade_usecase.dart';
import 'grade_management_event.dart';
import 'grade_management_state.dart';

class GradeManagementBloc
    extends Bloc<GradeManagementEvent, GradeManagementState> {
  final GetAllGradesUseCase getAllGradesUseCase;
  final CreateGradeUseCase createGradeUseCase;
  final UpdateGradeUseCase updateGradeUseCase;
  final DeleteGradeUseCase deleteGradeUseCase;

  GradeManagementBloc({
    required this.getAllGradesUseCase,
    required this.createGradeUseCase,
    required this.updateGradeUseCase,
    required this.deleteGradeUseCase,
  }) : super(const GradeManagementInitial()) {
    on<LoadGradesEvent>(_onLoadGrades);
    on<RefreshGradesEvent>(_onRefreshGrades);
    on<LoadMoreGradesEvent>(_onLoadMoreGrades);
    on<FilterGradesEvent>(_onFilterGrades);
    on<SortGradesEvent>(_onSortGrades);
    on<CreateGradeEvent>(_onCreateGrade);
    on<UpdateGradeEvent>(_onUpdateGrade);
    on<DeleteGradeEvent>(_onDeleteGrade);
    on<LoadGradeForEditEvent>(_onLoadGradeForEdit);
    on<ShowCreateFormEvent>(_onShowCreateForm);
    on<HideFormEvent>(_onHideForm);
    on<ResetFormEvent>(_onResetForm);
    on<ClearFormDataEvent>(_onClearFormData);
  }

  Future<void> _onLoadGrades(
    LoadGradesEvent event,
    Emitter<GradeManagementState> emit,
  ) async {
    emit(const GradeManagementLoading());

    final query = DefaultQueryEntity(
      page: AppConstants.defaultPage,
      limit: AppConstants.defaultLimit,
      sort: [
        {"name": "asc"},
      ],
      filter: {},
    );

    final result = await getAllGradesUseCase.call(query);

    result.fold(
      (failure) => emit(GradeManagementError(failure.message)),
      (grades) => emit(
        GradeManagementLoaded(
          grades: grades,
          hasReachedMax: grades.length < query.limit,
          currentQuery: query,
        ),
      ),
    );
  }

  Future<void> _onRefreshGrades(
    RefreshGradesEvent event,
    Emitter<GradeManagementState> emit,
  ) async {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;
      final refreshedQuery = current.currentQuery.copyWith(page: 1);

      final result = await getAllGradesUseCase.call(refreshedQuery);

      result.fold(
        (failure) => emit(GradeManagementError(failure.message)),
        (grades) => emit(
          current.copyWith(
            grades: grades,
            hasReachedMax: grades.length < refreshedQuery.limit,
            currentQuery: refreshedQuery,
          ),
        ),
      );
    }
  }

  Future<void> _onLoadMoreGrades(
    LoadMoreGradesEvent event,
    Emitter<GradeManagementState> emit,
  ) async {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;
      if (current.hasReachedMax) return;

      emit(
        GradeManagementLoadingMore(
          grades: current.grades,
          currentQuery: current.currentQuery,
        ),
      );

      final nextQuery = current.currentQuery.copyWith(
        page: current.currentQuery.page + 1,
      );

      final result = await getAllGradesUseCase.call(nextQuery);

      result.fold(
        (failure) => emit(GradeManagementError(failure.message)),
        (newGrades) => emit(
          current.copyWith(
            grades: [...current.grades, ...newGrades],
            hasReachedMax: newGrades.length < nextQuery.limit,
            currentQuery: nextQuery,
          ),
        ),
      );
    }
  }

  Future<void> _onFilterGrades(
    FilterGradesEvent event,
    Emitter<GradeManagementState> emit,
  ) async {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;
      emit(const GradeManagementLoading());

      final newQuery = current.currentQuery.copyWith(
        page: 1,
        filter: event.filter,
      );

      final result = await getAllGradesUseCase.call(newQuery);

      result.fold(
        (failure) => emit(GradeManagementError(failure.message)),
        (grades) => emit(
          current.copyWith(
            grades: grades,
            hasReachedMax: grades.length < newQuery.limit,
            currentQuery: newQuery,
          ),
        ),
      );
    }
  }

  Future<void> _onSortGrades(
    SortGradesEvent event,
    Emitter<GradeManagementState> emit,
  ) async {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;
      emit(const GradeManagementLoading());

      final newQuery = current.currentQuery.copyWith(page: 1, sort: event.sort);

      final result = await getAllGradesUseCase.call(newQuery);

      result.fold(
        (failure) => emit(GradeManagementError(failure.message)),
        (grades) => emit(
          current.copyWith(
            grades: grades,
            hasReachedMax: grades.length < newQuery.limit,
            currentQuery: newQuery,
          ),
        ),
      );
    }
  }

  Future<void> _onCreateGrade(
    CreateGradeEvent event,
    Emitter<GradeManagementState> emit,
  ) async {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;

      emit(
        GradeManagementFormLoading(
          grades: current.grades,
          currentQuery: current.currentQuery,
          isFormVisible: current.isFormVisible,
          isEditMode: current.isEditMode,
          gradeToEdit: current.gradeToEdit,
        ),
      );

      final result = await createGradeUseCase.call(event.gradeEntity);

      await result.fold(
        (failure) async {
          emit(
            current.copyWith(
              formStatus: GradeManagementFormStatus.error,
              formErrorMessage: failure.message,
            ),
          );
        },
        (success) async {
          // Reload logic
          final gradesResult = await getAllGradesUseCase.call(
            current.currentQuery,
          );

          gradesResult.fold(
            (failure) => emit(GradeManagementError(failure.message)),
            (grades) => emit(
              current.copyWith(
                grades: grades,
                formStatus: GradeManagementFormStatus.success,
                isFormVisible: false,
                isEditMode: false,
                clearGradeToEdit: true,
                clearFormErrorMessage: true,
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> _onUpdateGrade(
    UpdateGradeEvent event,
    Emitter<GradeManagementState> emit,
  ) async {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;

      emit(
        GradeManagementFormLoading(
          grades: current.grades,
          currentQuery: current.currentQuery,
          isFormVisible: current.isFormVisible,
          isEditMode: current.isEditMode,
          gradeToEdit: current.gradeToEdit,
        ),
      );

      final result = await updateGradeUseCase.call(event.gradeEntity);

      result.fold(
        (failure) {
          emit(
            current.copyWith(
              formStatus: GradeManagementFormStatus.error,
              formErrorMessage: failure.message,
            ),
          );
        },
        (updatedGrade) {
          final updatedGrades = current.grades
              .map((g) => g.id == event.gradeEntity.id ? event.gradeEntity : g)
              .toList();

          emit(
            current.copyWith(
              grades: updatedGrades,
              formStatus: GradeManagementFormStatus.success,
              isFormVisible: false,
              isEditMode: false,
              clearGradeToEdit: true,
              clearFormErrorMessage: true,
            ),
          );
        },
      );
    }
  }

  Future<void> _onDeleteGrade(
    DeleteGradeEvent event,
    Emitter<GradeManagementState> emit,
  ) async {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;

      final result = await deleteGradeUseCase.call(event.gradeId);

      result.fold((failure) => emit(GradeManagementError(failure.message)), (
        _,
      ) {
        final remaining = current.grades
            .where((g) => g.id != event.gradeId)
            .toList();
        emit(current.copyWith(grades: remaining));
      });
    }
  }

  Future<void> _onLoadGradeForEdit(
    LoadGradeForEditEvent event,
    Emitter<GradeManagementState> emit,
  ) async {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;
      emit(
        current.copyWith(
          isFormVisible: true,
          isEditMode: true,
          gradeToEdit: event.gradeToEdit,
          formStatus: GradeManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }

  void _onShowCreateForm(
    ShowCreateFormEvent event,
    Emitter<GradeManagementState> emit,
  ) {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;
      emit(
        current.copyWith(
          isFormVisible: true,
          isEditMode: false,
          clearGradeToEdit: true,
          formStatus: GradeManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }

  void _onHideForm(HideFormEvent event, Emitter<GradeManagementState> emit) {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;
      emit(
        current.copyWith(
          isFormVisible: false,
          isEditMode: false,
          clearGradeToEdit: true,
          formStatus: GradeManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }

  void _onResetForm(ResetFormEvent event, Emitter<GradeManagementState> emit) {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;
      emit(
        current.copyWith(
          formStatus: GradeManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }

  void _onClearFormData(
    ClearFormDataEvent event,
    Emitter<GradeManagementState> emit,
  ) {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;
      emit(
        current.copyWith(
          clearGradeToEdit: true,
          isEditMode: false,
          formStatus: GradeManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }
}
