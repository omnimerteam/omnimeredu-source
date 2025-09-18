// class_management_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/create_class_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/delete_class_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/get_all_class_detail_view_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/get_class_by_id_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/class/update_class_usecase.dart';
import 'class_management_event.dart';
import 'class_management_state.dart';

class ClassManagementBloc
    extends Bloc<ClassManagementEvent, ClassManagementState> {
  final GetAllClassDetailViewUseCase getAllClassDetailViewUseCase;
  final CreateClassUseCase createClassUseCase;
  final UpdateClassUseCase updateClassUseCase;
  final DeleteClassUseCase deleteClassUseCase;
  final GetClassByIdUseCase getClassByIdUseCase;

  ClassManagementBloc({
    required this.getAllClassDetailViewUseCase,
    required this.createClassUseCase,
    required this.updateClassUseCase,
    required this.deleteClassUseCase,
    required this.getClassByIdUseCase,
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
      final defaultSort = <String, String>{"name": "asc"};
      final classes = await getAllClassDetailViewUseCase.call(
        page: AppConstants.defaultPage,
        limit: AppConstants.defaultLimit,
        sort: defaultSort,
      );

      emit(
        ClassManagementLoaded(
          classes: classes,
          hasReachedMax: classes.length < AppConstants.defaultLimit,
          currentPage: AppConstants.defaultPage,
          currentSort: defaultSort,
          currentFilter: {},
        ),
      );
    } catch (error) {
      emit(ClassManagementError(error.toString()));
    }
  }

  Future<void> _onRefreshClasses(
    RefreshClassesEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    if (state is ClassManagementLoaded) {
      final currentState = state as ClassManagementLoaded;

      try {
        final classes = await getAllClassDetailViewUseCase.call(
          page: AppConstants.defaultPage,
          limit: AppConstants.defaultLimit,
          sort: currentState.currentSort,
          filter: currentState.currentFilter,
        );

        emit(
          currentState.copyWith(
            classes: classes,
            hasReachedMax: classes.length < AppConstants.defaultLimit,
            currentPage: AppConstants.defaultPage,
          ),
        );
      } catch (error) {
        emit(ClassManagementError(error.toString()));
      }
    }
  }

  Future<void> _onLoadMoreClasses(
    LoadMoreClassesEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    if (state is ClassManagementLoaded) {
      final currentState = state as ClassManagementLoaded;

      if (currentState.hasReachedMax) return;

      emit(
        ClassManagementLoadingMore(
          classes: currentState.classes,
          currentSort: currentState.currentSort,
          currentFilter: currentState.currentFilter,
        ),
      );

      try {
        final nextPage = currentState.currentPage + 1;
        final newClasses = await getAllClassDetailViewUseCase.call(
          page: nextPage,
          limit: AppConstants.defaultLimit,
          sort: currentState.currentSort,
          filter: currentState.currentFilter,
        );

        emit(
          currentState.copyWith(
            classes: [...currentState.classes, ...newClasses],
            hasReachedMax: newClasses.length < AppConstants.defaultLimit,
            currentPage: nextPage,
          ),
        );
      } catch (error) {
        emit(ClassManagementError(error.toString()));
      }
    }
  }

  Future<void> _onFilterClasses(
    FilterClassesEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    if (state is ClassManagementLoaded) {
      final currentState = state as ClassManagementLoaded;

      emit(const ClassManagementLoading());

      try {
        final classes = await getAllClassDetailViewUseCase.call(
          page: AppConstants.defaultPage,
          limit: AppConstants.defaultLimit,
          sort: currentState.currentSort,
          filter: event.filter,
        );

        emit(
          currentState.copyWith(
            classes: classes,
            hasReachedMax: classes.length < AppConstants.defaultLimit,
            currentPage: AppConstants.defaultPage,
            currentFilter: event.filter,
          ),
        );
      } catch (error) {
        emit(ClassManagementError(error.toString()));
      }
    }
  }

  Future<void> _onSortClasses(
    SortClassesEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    if (state is ClassManagementLoaded) {
      final currentState = state as ClassManagementLoaded;

      emit(const ClassManagementLoading());

      try {
        final classes = await getAllClassDetailViewUseCase.call(
          page: AppConstants.defaultPage,
          limit: AppConstants.defaultLimit,
          sort: event.sort,
          filter: currentState.currentFilter,
        );

        emit(
          currentState.copyWith(
            classes: classes,
            hasReachedMax: classes.length < AppConstants.defaultLimit,
            currentPage: AppConstants.defaultPage,
            currentSort: event.sort,
          ),
        );
      } catch (error) {
        emit(ClassManagementError(error.toString()));
      }
    }
  }

  Future<void> _onCreateClass(
    CreateClassEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    if (state is ClassManagementLoaded) {
      final currentState = state as ClassManagementLoaded;

      emit(
        ClassManagementFormLoading(
          classes: currentState.classes,
          currentSort: currentState.currentSort,
          currentFilter: currentState.currentFilter,
          isFormVisible: currentState.isFormVisible,
          isEditMode: currentState.isEditMode,
          classToEdit: currentState.classToEdit,
        ),
      );

      try {
        await createClassUseCase.call(event.classEntity);

        emit(
          currentState.copyWith(
            formStatus: ClassManagementFormStatus.success,
            isFormVisible: false,
            clearClassToEdit: true,
            clearFormErrorMessage: true,
          ),
        );

        // Refresh the list
        add(const RefreshClassesEvent());
      } catch (error) {
        emit(
          currentState.copyWith(
            formStatus: ClassManagementFormStatus.error,
            formErrorMessage: error.toString(),
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
      final currentState = state as ClassManagementLoaded;

      emit(
        ClassManagementFormLoading(
          classes: currentState.classes,
          currentSort: currentState.currentSort,
          currentFilter: currentState.currentFilter,
          isFormVisible: currentState.isFormVisible,
          isEditMode: currentState.isEditMode,
          classToEdit: currentState.classToEdit,
        ),
      );

      try {
        await updateClassUseCase.call(event.classEntity);

        emit(
          currentState.copyWith(
            formStatus: ClassManagementFormStatus.success,
            isFormVisible: false,
            isEditMode: false,
            clearClassToEdit: true,
            clearFormErrorMessage: true,
          ),
        );

        // Refresh the list
        add(const RefreshClassesEvent());
      } catch (error) {
        emit(
          currentState.copyWith(
            formStatus: ClassManagementFormStatus.error,
            formErrorMessage: error.toString(),
          ),
        );
      }
    }
  }

  Future<void> _onDeleteClass(
    DeleteClassEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    try {
      logger.i("Id deleted: ${event.classId}");
      await deleteClassUseCase.call(event.classId);

      // Refresh the list
      add(const RefreshClassesEvent());
    } catch (error) {
      emit(ClassManagementError(error.toString()));
    }
  }

  Future<void> _onLoadClassForEdit(
    LoadClassForEditEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    if (state is ClassManagementLoaded) {
      final currentState = state as ClassManagementLoaded;

      emit(
        ClassManagementFormLoading(
          classes: currentState.classes,
          currentSort: currentState.currentSort,
          currentFilter: currentState.currentFilter,
          isFormVisible: true,
          isEditMode: true,
        ),
      );

      try {
        final classEntity = await getClassByIdUseCase.call(event.classId);
        logger.i("Thông tin update: ${classEntity}");

        emit(
          currentState.copyWith(
            formStatus: ClassManagementFormStatus.initial,
            isFormVisible: true,
            isEditMode: true,
            classToEdit: classEntity,
            clearFormErrorMessage: true,
          ),
        );
      } catch (error) {
        emit(
          currentState.copyWith(
            formStatus: ClassManagementFormStatus.error,
            formErrorMessage: error.toString(),
          ),
        );
      }
    }
  }

  void _onShowCreateForm(
    ShowCreateFormEvent event,
    Emitter<ClassManagementState> emit,
  ) {
    if (state is ClassManagementLoaded) {
      final currentState = state as ClassManagementLoaded;

      emit(
        currentState.copyWith(
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
      final currentState = state as ClassManagementLoaded;

      emit(
        currentState.copyWith(
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
      final currentState = state as ClassManagementLoaded;

      emit(
        currentState.copyWith(
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
      final currentState = state as ClassManagementLoaded;

      emit(
        currentState.copyWith(
          clearClassToEdit: true,
          isEditMode: false,
          formStatus: ClassManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }
}
