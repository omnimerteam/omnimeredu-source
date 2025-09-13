// class_management_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/app_constants.dart';
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
  }) : super(const ClassManagementState()) {
    on<LoadClassesEvent>(_onLoadClasses);
    on<ChangeSortStringEvent>(_onChangeSortString);
    on<ChangeSortEvent>(_onChangeSort); // Keep for backward compatibility
    on<ChangePageEvent>(_onChangePage);
    on<CreateClassEvent>(_onCreateClass);
    on<UpdateClassEvent>(_onUpdateClass);
    on<DeleteClassEvent>(_onDeleteClass);
    on<LoadClassForEditEvent>(_onLoadClassForEdit);
    on<ShowCreateFormEvent>(_onShowCreateForm);
    on<HideFormEvent>(_onHideForm);
    on<ResetFormEvent>(_onResetForm);
  }

  Future<void> _onLoadClasses(
    LoadClassesEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ClassManagementStatus.loading));

      final classes = await getAllClassDetailViewUseCase.call(
        event.sort ?? AppConstants.nameSort,
        page: event.page ?? AppConstants.defaultPage,
        limit: AppConstants.defaultLimit,
      );

      emit(
        state.copyWith(
          status: ClassManagementStatus.loaded,
          classes: classes,
          currentPage: event.page,
          hasMorePages: classes.length == AppConstants.defaultLimit,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ClassManagementStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onChangeSortString(
    ChangeSortStringEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    emit(
      state.copyWith(
        sortString: event.sortString,
        currentPage: AppConstants.defaultPage, // Reset to first page
      ),
    );

    // Reload with new sort
    add(
      LoadClassesEvent(page: AppConstants.defaultPage, sort: event.sortString),
    );
  }

  // Keep the old method for backward compatibility
  Future<void> _onChangeSort(
    ChangeSortEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    String newSortString;

    // If clicking the same field, toggle direction
    if (state.currentSortField == event.sortField) {
      final newDirection = state.isAscending ? 'desc' : 'asc';
      newSortString = '${event.sortField}:$newDirection';
    } else {
      // New field, default to ascending
      newSortString = '${event.sortField}:asc';
    }

    emit(
      state.copyWith(
        sortString: newSortString,
        currentPage: AppConstants.defaultPage,
      ),
    );

    // Reload with new sort
    add(LoadClassesEvent(page: AppConstants.defaultPage, sort: newSortString));
  }

  Future<void> _onChangePage(
    ChangePageEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    add(LoadClassesEvent(page: event.page, sort: state.sortString));
  }

  Future<void> _onCreateClass(
    CreateClassEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    try {
      emit(state.copyWith(formStatus: ClassManagementStatus.formLoading));

      await createClassUseCase.call(event.classEntity);

      emit(
        state.copyWith(
          formStatus: ClassManagementStatus.formSuccess,
          isFormVisible: false,
        ),
      );

      // Reload the list
      add(LoadClassesEvent(page: state.currentPage, sort: state.sortString));
    } catch (e) {
      emit(
        state.copyWith(
          formStatus: ClassManagementStatus.formError,
          formErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateClass(
    UpdateClassEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    try {
      emit(state.copyWith(formStatus: ClassManagementStatus.formLoading));

      await updateClassUseCase.call(event.classEntity);

      emit(
        state.copyWith(
          formStatus: ClassManagementStatus.formSuccess,
          isFormVisible: false,
          isEditMode: false,
          classToEdit: null,
        ),
      );

      // Reload the list
      add(LoadClassesEvent(page: state.currentPage, sort: state.sortString));
    } catch (e) {
      emit(
        state.copyWith(
          formStatus: ClassManagementStatus.formError,
          formErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteClass(
    DeleteClassEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    try {
      logger.i("Id deleted: ${event.classId}");
      await deleteClassUseCase.call(event.classId);

      // Reload the list
      add(LoadClassesEvent(page: state.currentPage, sort: state.sortString));
    } catch (e) {
      emit(
        state.copyWith(
          status: ClassManagementStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadClassForEdit(
    LoadClassForEditEvent event,
    Emitter<ClassManagementState> emit,
  ) async {
    try {
      emit(state.copyWith(formStatus: ClassManagementStatus.formLoading));

      final classEntity = await getClassByIdUseCase.call(event.classId);
      logger.i("Thông tin update: ${classEntity}");
      emit(
        state.copyWith(
          formStatus: ClassManagementStatus.loaded,
          isFormVisible: true,
          isEditMode: true,
          classToEdit: classEntity,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          formStatus: ClassManagementStatus.formError,
          formErrorMessage: e.toString(),
        ),
      );
    }
  }

  void _onShowCreateForm(
    ShowCreateFormEvent event,
    Emitter<ClassManagementState> emit,
  ) {
    emit(
      state.copyWith(
        isFormVisible: true,
        isEditMode: false,
        classToEdit: null,
        formStatus: ClassManagementStatus.initial,
        formErrorMessage: null,
      ),
    );
  }

  void _onHideForm(HideFormEvent event, Emitter<ClassManagementState> emit) {
    emit(
      state.copyWith(
        isFormVisible: false,
        isEditMode: false,
        classToEdit: null,
        formStatus: ClassManagementStatus.initial,
        formErrorMessage: null,
      ),
    );
  }

  void _onResetForm(ResetFormEvent event, Emitter<ClassManagementState> emit) {
    emit(
      state.copyWith(
        formStatus: ClassManagementStatus.initial,
        formErrorMessage: null,
      ),
    );
  }
}
