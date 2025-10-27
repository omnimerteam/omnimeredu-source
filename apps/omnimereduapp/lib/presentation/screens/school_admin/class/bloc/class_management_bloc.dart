import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../domain/entities/query/default_query_entity.dart';
import '../../../../../domain/usecases/class/create_class_usecase.dart';
import '../../../../../domain/usecases/class/delete_class_usecase.dart';
import '../../../../../domain/usecases/class/get_all_class_usecase.dart';
import '../../../../../domain/usecases/class/update_class_usecase.dart';
import 'class_management_event.dart';
import 'class_management_state.dart';

class ClassManagementBloc
    extends Bloc<ClassManagementEvent, ClassManagementState> {
  final GetAllClassUseCase getAllClassUseCase;
  final CreateClassUseCase createClassUseCase;
  final UpdateClassUseCase updateClassUseCase;
  final DeleteClassUseCase deleteClassUseCase;

  ClassManagementBloc({
    required this.getAllClassUseCase,
    required this.createClassUseCase,
    required this.updateClassUseCase,
    required this.deleteClassUseCase,
  }) : super(const ClassManagementInitial()) {
    on<LoadClassesEvent>(_onLoadClasses);
    on<RefreshClassesEvent>(_onRefreshClasses);
    on<LoadMoreClassesEvent>(_onLoadMoreClasses);
    on<FilterClassesEvent>(_onFilterClasses);
    on<SortClassesEvent>(_onSortClasses);
    on<CreateClassEvent>(_onCreateClass);
    on<UpdateClassEvent>(_onUpdateClass);
    on<DeleteClassEvent>(_onDeleteClass);
    on<LoadClassForEditEvent>(_onLoadClassForEdit);
    on<ShowCreateFormEvent>(_onShowCreateForm);
    on<HideFormEvent>(_onHideForm);
    on<ResetFormEvent>(_onResetForm);
    on<ClearFormDataEvent>(_onClearFormData);
  }

  Future<void> _onLoadClasses(
    LoadClassesEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    emit(const ClassManagementLoading());
    try {
      final query = event.query ?? DefaultQueryEntity();
      final classes = await getAllClassUseCase.call(query);
      emit(
        ClassManagementLoaded(
          classes: classes,
          hasReachedMax: classes.length < query.limit,
          currentQuery: query,
        ),
      );
    } catch (e) {
      emit(ClassManagementError(e.toString()));
    }
  }

  Future<void> _onRefreshClasses(
    RefreshClassesEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    if (state is ClassManagementLoaded) {
      final current = state as ClassManagementLoaded;
      final refreshedQuery = current.currentQuery.copyWith(page: 1);
      emit(const ClassManagementLoading());
      try {
        final classes = await getAllClassUseCase.call(refreshedQuery);
        emit(
          current.copyWith(
            classes: classes,
            hasReachedMax: classes.length < refreshedQuery.limit,
            currentQuery: refreshedQuery,
          ),
        );
      } catch (e) {
        emit(ClassManagementError(e.toString()));
      }
    }
  }

  Future<void> _onLoadMoreClasses(
    LoadMoreClassesEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    if (state is ClassManagementLoaded) {
      final current = state as ClassManagementLoaded;
      if (current.hasReachedMax) return;

      emit(
        ClassManagementLoadingMore(
          classes: current.classes,
          currentQuery: current.currentQuery,
        ),
      );

      try {
        final nextQuery = current.currentQuery.copyWith(
          page: current.currentQuery.page + 1,
        );
        final newClasses = await getAllClassUseCase.call(nextQuery);
        emit(
          current.copyWith(
            classes: [...current.classes, ...newClasses],
            hasReachedMax: newClasses.length < nextQuery.limit,
            currentQuery: nextQuery,
          ),
        );
      } catch (e) {
        emit(ClassManagementError(e.toString()));
      }
    }
  }

  Future<void> _onFilterClasses(
    FilterClassesEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    if (state is ClassManagementLoaded) {
      final current = state as ClassManagementLoaded;
      final newQuery = current.currentQuery.copyWith(
        page: 1,
        filter: event.filter,
      );
      emit(const ClassManagementLoading());
      try {
        final classes = await getAllClassUseCase.call(newQuery);
        emit(
          current.copyWith(
            classes: classes,
            hasReachedMax: classes.length < newQuery.limit,
            currentQuery: newQuery,
          ),
        );
      } catch (e) {
        emit(ClassManagementError(e.toString()));
      }
    }
  }

  Future<void> _onSortClasses(
    SortClassesEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    if (state is ClassManagementLoaded) {
      final current = state as ClassManagementLoaded;
      final newQuery = current.currentQuery.copyWith(page: 1, sort: event.sort);
      emit(const ClassManagementLoading());
      try {
        final classes = await getAllClassUseCase.call(newQuery);
        emit(
          current.copyWith(
            classes: classes,
            hasReachedMax: classes.length < newQuery.limit,
            currentQuery: newQuery,
          ),
        );
      } catch (e) {
        emit(ClassManagementError(e.toString()));
      }
    }
  }

  Future<void> _onCreateClass(
    CreateClassEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    if (state is ClassManagementLoaded) {
      final current = state as ClassManagementLoaded;
      emit(
        ClassManagementFormLoading(
          classes: current.classes,
          currentQuery: current.currentQuery,
          isFormVisible: current.isFormVisible,
          isEditMode: current.isEditMode,
          classToEdit: current.classToEdit,
        ),
      );

      try {
        final newClass = await createClassUseCase.call(event.classEntity);
        emit(
          current.copyWith(
            classes: [...current.classes, newClass],
            formStatus: ClassManagementFormStatus.success,
            isFormVisible: false,
            isEditMode: false,
            clearClassToEdit: true,
            clearFormErrorMessage: true,
          ),
        );
      } catch (e) {
        emit(
          current.copyWith(
            formStatus: ClassManagementFormStatus.error,
            formErrorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> _onUpdateClass(
    UpdateClassEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    if (state is ClassManagementLoaded) {
      final current = state as ClassManagementLoaded;
      emit(
        ClassManagementFormLoading(
          classes: current.classes,
          currentQuery: current.currentQuery,
          isFormVisible: current.isFormVisible,
          isEditMode: current.isEditMode,
          classToEdit: current.classToEdit,
        ),
      );

      try {
        final updatedClass = await updateClassUseCase.call(event.classEntity);
        final updatedList = current.classes
            .map((c) => c.id == updatedClass.id ? updatedClass : c)
            .toList();
        emit(
          current.copyWith(
            classes: updatedList,
            formStatus: ClassManagementFormStatus.success,
            isFormVisible: false,
            isEditMode: false,
            clearClassToEdit: true,
            clearFormErrorMessage: true,
          ),
        );
      } catch (e) {
        emit(
          current.copyWith(
            formStatus: ClassManagementFormStatus.error,
            formErrorMessage: e.toString(),
          ),
        );
      }
    }
  }

  Future<void> _onDeleteClass(
    DeleteClassEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    if (state is ClassManagementLoaded) {
      final current = state as ClassManagementLoaded;
      try {
        await deleteClassUseCase.call(event.classId);
        final remaining = current.classes
            .where((c) => c.id != event.classId)
            .toList();
        emit(current.copyWith(classes: remaining));
      } catch (e) {
        emit(ClassManagementError(e.toString()));
      }
    }
  }

  Future<void> _onLoadClassForEdit(
    LoadClassForEditEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    if (state is ClassManagementLoaded) {
      final current = state as ClassManagementLoaded;
      emit(
        current.copyWith(
          isFormVisible: true,
          isEditMode: true,
          classToEdit: event.classEdit,
          formStatus: ClassManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }

  void _onShowCreateForm(
    ShowCreateFormEvent event,
    Emitter<ClassManagementState> emit,
  ) {
    if (state is ClassManagementLoaded) {
      final current = state as ClassManagementLoaded;
      emit(
        current.copyWith(
          isFormVisible: true,
          isEditMode: false,
          clearClassToEdit: true,
          formStatus: ClassManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }

  void _onHideForm(HideFormEvent event, Emitter<ClassManagementState> emit) {
    if (state is ClassManagementLoaded) {
      final current = state as ClassManagementLoaded;
      emit(
        current.copyWith(
          isFormVisible: false,
          isEditMode: false,
          clearClassToEdit: true,
          formStatus: ClassManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }

  void _onResetForm(ResetFormEvent event, Emitter<ClassManagementState> emit) {
    if (state is ClassManagementLoaded) {
      final current = state as ClassManagementLoaded;
      emit(
        current.copyWith(
          formStatus: ClassManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }

  void _onClearFormData(
    ClearFormDataEvent event,
    Emitter<ClassManagementState> emit,
  ) {
    if (state is ClassManagementLoaded) {
      final current = state as ClassManagementLoaded;
      emit(
        current.copyWith(
          clearClassToEdit: true,
          isEditMode: false,
          formStatus: ClassManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }
}
