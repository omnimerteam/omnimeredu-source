import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';

import 'package:flutter_ios_android_platforms/domain/usecases/grade/create_grade_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/grade/delete_grade_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/grade/get_all_grades_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/grade/update_grade_usecase.dart';
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

    try {
      final query = DefaultQueryEntity(
        page: AppConstants.defaultPage,
        limit: AppConstants.defaultLimit,
        sort: [
          {"name": "asc"},
        ],
        filter: {},
      );

      final grades = await getAllGradesUseCase.call(query);

      emit(
        GradeManagementLoaded(
          grades: grades,
          hasReachedMax: grades.length < query.limit,
          currentQuery: query,
        ),
      );
    } catch (error) {
      emit(GradeManagementError(error.toString()));
    }
  }

  Future<void> _onRefreshGrades(
    RefreshGradesEvent event,
    Emitter<GradeManagementState> emit,
  ) async {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;

      try {
        final refreshedQuery = current.currentQuery.copyWith(page: 1);
        final grades = await getAllGradesUseCase.call(refreshedQuery);

        emit(
          current.copyWith(
            grades: grades,
            hasReachedMax: grades.length < refreshedQuery.limit,
            currentQuery: refreshedQuery,
          ),
        );
      } catch (error) {
        emit(GradeManagementError(error.toString()));
      }
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

      try {
        final nextQuery = current.currentQuery.copyWith(
          page: current.currentQuery.page + 1,
        );
        final newGrades = await getAllGradesUseCase.call(nextQuery);

        emit(
          current.copyWith(
            grades: [...current.grades, ...newGrades],
            hasReachedMax: newGrades.length < nextQuery.limit,
            currentQuery: nextQuery,
          ),
        );
      } catch (error) {
        emit(GradeManagementError(error.toString()));
      }
    }
  }

  Future<void> _onFilterGrades(
    FilterGradesEvent event,
    Emitter<GradeManagementState> emit,
  ) async {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;

      emit(const GradeManagementLoading());

      try {
        final newQuery = current.currentQuery.copyWith(
          page: 1,
          filter: event.filter,
        );
        final grades = await getAllGradesUseCase.call(newQuery);

        emit(
          current.copyWith(
            grades: grades,
            hasReachedMax: grades.length < newQuery.limit,
            currentQuery: newQuery,
          ),
        );
      } catch (error) {
        emit(GradeManagementError(error.toString()));
      }
    }
  }

  Future<void> _onSortGrades(
    SortGradesEvent event,
    Emitter<GradeManagementState> emit,
  ) async {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;

      emit(const GradeManagementLoading());

      try {
        final newQuery = current.currentQuery.copyWith(
          page: 1,
          sort: event.sort,
        );
        final grades = await getAllGradesUseCase.call(newQuery);

        emit(
          current.copyWith(
            grades: grades,
            hasReachedMax: grades.length < newQuery.limit,
            currentQuery: newQuery,
          ),
        );
      } catch (error) {
        emit(GradeManagementError(error.toString()));
      }
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

      try {
        await createGradeUseCase.call(event.gradeEntity);

        // refresh
        final grades = await getAllGradesUseCase.call(current.currentQuery);

        emit(
          current.copyWith(
            grades: grades,
            formStatus: GradeManagementFormStatus.success,
            isFormVisible: false,
            isEditMode: false,
            clearGradeToEdit: true,
            clearFormErrorMessage: true,
          ),
        );
      } catch (error) {
        emit(
          current.copyWith(
            formStatus: GradeManagementFormStatus.error,
            formErrorMessage: error.toString(),
          ),
        );
      }
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

      try {
        await updateGradeUseCase.call(event.gradeEntity);

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
      } catch (error) {
        emit(
          current.copyWith(
            formStatus: GradeManagementFormStatus.error,
            formErrorMessage: error.toString(),
          ),
        );
      }
    }
  }

  Future<void> _onDeleteGrade(
    DeleteGradeEvent event,
    Emitter<GradeManagementState> emit,
  ) async {
    if (state is GradeManagementLoaded) {
      final current = state as GradeManagementLoaded;

      try {
        await deleteGradeUseCase.call(event.gradeId);

        final remaining = current.grades
            .where((g) => g.id != event.gradeId)
            .toList();

        emit(current.copyWith(grades: remaining));
      } catch (error) {
        emit(GradeManagementError(error.toString()));
      }
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
