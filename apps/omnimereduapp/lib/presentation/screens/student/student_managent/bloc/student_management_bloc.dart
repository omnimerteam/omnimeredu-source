import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../domain/entities/query/default_query_entity.dart';
import '../../../../../domain/usecases/student/create_student_usecase.dart';
import '../../../../../domain/usecases/student/delete_student_usecase.dart';
import '../../../../../domain/usecases/student/get_all_students_usecase.dart';
import '../../../../../domain/usecases/student/get_student_by_id_usecase.dart';
import '../../../../../domain/usecases/student/update_student_usecase.dart';
import 'student_management_event.dart';
import 'student_management_state.dart';

class StudentManagementBloc
    extends Bloc<StudentManagementEvent, StudentManagementState> {
  final GetAllStudentsUseCase getAllStudentsUseCase;
  final CreateStudentUseCase createStudentUseCase;
  final UpdateStudentUseCase updateStudentUseCase;
  final DeleteStudentUseCase deleteStudentUseCase;
  final GetStudentByIdUseCase getStudentByIdUseCase;

  StudentManagementBloc({
    required this.getAllStudentsUseCase,
    required this.createStudentUseCase,
    required this.updateStudentUseCase,
    required this.deleteStudentUseCase,
    required this.getStudentByIdUseCase,
  }) : super(const StudentManagementInitial()) {
    on<LoadStudentsEvent>(_onLoadStudents);
    on<RefreshStudentsEvent>(_onRefreshStudents);
    on<LoadMoreStudentsEvent>(_onLoadMoreStudents);
    on<FilterStudentsEvent>(_onFilterStudents);
    on<SortStudentsEvent>(_onSortStudents);
    on<SearchStudentsEvent>(_onSearchStudents);
    on<CreateStudentEvent>(_onCreateStudent);
    on<UpdateStudentEvent>(_onUpdateStudent);
    on<DeleteStudentEvent>(_onDeleteStudent);
    on<LoadStudentByIdEvent>(_onLoadStudentById);
    on<LoadStudentForEditEvent>(_onLoadStudentForEdit);
    on<ShowCreateFormEvent>(_onShowCreateForm);
    on<HideFormEvent>(_onHideForm);
    on<ResetFormEvent>(_onResetForm);
    on<ClearFormDataEvent>(_onClearFormData);
    on<ShowStudentDetailsEvent>(_onShowStudentDetails);
    on<HideStudentDetailsEvent>(_onHideStudentDetails);
  }

  Future<void> _onLoadStudents(
    LoadStudentsEvent event,
    Emitter<StudentManagementState> emit,
  ) async {
    emit(const StudentManagementLoading());
    try {
      final query =
          event.query ??
          DefaultQueryEntity(
            sort: [
              {'createdAt': 'desc'},
            ], // Mặc định sort theo createdAt từ mới nhất
          );
      final students = await getAllStudentsUseCase.call(query);
      emit(
        StudentManagementLoaded(
          students: students,
          hasReachedMax: students.length < query.limit,
          currentQuery: query,
        ),
      );
    } catch (e) {
      emit(StudentManagementError(e.toString()));
    }
  }

  Future<void> _onRefreshStudents(
    RefreshStudentsEvent event,
    Emitter<StudentManagementState> emit,
  ) async {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;
      final refreshedQuery = current.currentQuery.copyWith(page: 1);
      emit(const StudentManagementLoading());
      try {
        final students = await getAllStudentsUseCase.call(refreshedQuery);
        emit(
          current.copyWith(
            students: students,
            hasReachedMax: students.length < refreshedQuery.limit,
            currentQuery: refreshedQuery,
          ),
        );
      } catch (e) {
        emit(StudentManagementError(e.toString()));
      }
    }
  }

  Future<void> _onLoadMoreStudents(
    LoadMoreStudentsEvent event,
    Emitter<StudentManagementState> emit,
  ) async {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;
      if (current.hasReachedMax) return;

      emit(
        StudentManagementLoadingMore(
          students: current.students,
          currentQuery: current.currentQuery,
        ),
      );

      try {
        final nextQuery = current.currentQuery.copyWith(
          page: current.currentQuery.page + 1,
        );
        final newStudents = await getAllStudentsUseCase.call(nextQuery);
        emit(
          current.copyWith(
            students: [...current.students, ...newStudents],
            hasReachedMax: newStudents.length < nextQuery.limit,
            currentQuery: nextQuery,
          ),
        );
      } catch (e) {
        emit(StudentManagementError(e.toString()));
      }
    }
  }

  Future<void> _onFilterStudents(
    FilterStudentsEvent event,
    Emitter<StudentManagementState> emit,
  ) async {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;
      final newQuery = current.currentQuery.copyWith(
        page: 1,
        filter: event.filter,
      );
      emit(const StudentManagementLoading());
      try {
        final students = await getAllStudentsUseCase.call(newQuery);
        emit(
          current.copyWith(
            students: students,
            hasReachedMax: students.length < newQuery.limit,
            currentQuery: newQuery,
          ),
        );
      } catch (e) {
        emit(StudentManagementError(e.toString()));
      }
    }
  }

  Future<void> _onSortStudents(
    SortStudentsEvent event,
    Emitter<StudentManagementState> emit,
  ) async {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;
      final newQuery = current.currentQuery.copyWith(page: 1, sort: event.sort);
      emit(const StudentManagementLoading());
      try {
        final students = await getAllStudentsUseCase.call(newQuery);
        emit(
          current.copyWith(
            students: students,
            hasReachedMax: students.length < newQuery.limit,
            currentQuery: newQuery,
          ),
        );
      } catch (e) {
        emit(StudentManagementError(e.toString()));
      }
    }
  }

  Future<void> _onSearchStudents(
    SearchStudentsEvent event,
    Emitter<StudentManagementState> emit,
  ) async {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;
      final newQuery = current.currentQuery.copyWith(
        page: 1,
        search: event.search.trim().isEmpty ? null : event.search.trim(),
      );
      emit(const StudentManagementLoading());
      try {
        final students = await getAllStudentsUseCase.call(newQuery);
        emit(
          current.copyWith(
            students: students,
            hasReachedMax: students.length < newQuery.limit,
            currentQuery: newQuery,
          ),
        );
      } catch (e) {
        emit(StudentManagementError(e.toString()));
      }
    }
  }

  Future<void> _onCreateStudent(
    CreateStudentEvent event,
    Emitter<StudentManagementState> emit,
  ) async {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;

      emit(current.copyWith(formStatus: StudentManagementFormStatus.loading));

      try {
        final newStudent = await createStudentUseCase.call(event.studentEntity);

        emit(
          current.copyWith(
            students: [newStudent, ...current.students],
            formStatus: StudentManagementFormStatus.success,
            isFormVisible: false,
            isEditMode: false,
            clearStudentToEdit: true,
            clearFormErrorMessage: true,
          ),
        );
      } catch (e) {
        emit(
          current.copyWith(
            formStatus: StudentManagementFormStatus.error,
            formErrorMessage: e.toString(),
            isFormVisible: true,
          ),
        );
      }
    }
  }

  Future<void> _onUpdateStudent(
    UpdateStudentEvent event,
    Emitter<StudentManagementState> emit,
  ) async {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;

      emit(current.copyWith(formStatus: StudentManagementFormStatus.loading));

      try {
        final updatedStudent = await updateStudentUseCase.call(
          event.studentEntity,
        );
        final updatedList = current.students
            .map((s) => s.id == updatedStudent.id ? updatedStudent : s)
            .toList();
        emit(
          current.copyWith(
            students: updatedList,
            formStatus: StudentManagementFormStatus.success,
            isFormVisible: false,
            isEditMode: false,
            clearStudentToEdit: true,
            clearFormErrorMessage: true,
          ),
        );
      } catch (e) {
        logger.e("error update ${e}");
        emit(
          current.copyWith(
            formStatus: StudentManagementFormStatus.error,
            formErrorMessage: e.toString(),
            isFormVisible: true,
          ),
        );
      }
    }
  }

  Future<void> _onDeleteStudent(
    DeleteStudentEvent event,
    Emitter<StudentManagementState> emit,
  ) async {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;
      try {
        await deleteStudentUseCase.call(event.studentId);
        final remaining = current.students
            .where((s) => s.id != event.studentId)
            .toList();
        emit(current.copyWith(students: remaining));
      } catch (e) {
        emit(StudentManagementError(e.toString()));
      }
    }
  }

  Future<void> _onLoadStudentById(
    LoadStudentByIdEvent event,
    Emitter<StudentManagementState> emit,
  ) async {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;
      emit(
        current.copyWith(
          isLoadingDetails: true,
          clearDetailsErrorMessage: true,
        ),
      );

      try {
        final studentDetails = await getStudentByIdUseCase.call(
          event.studentId,
        );
        emit(
          current.copyWith(
            selectedStudentDetails: studentDetails,
            isDetailsVisible: true,
            isLoadingDetails: false,
          ),
        );
      } catch (e) {
        emit(
          current.copyWith(
            detailsErrorMessage: e.toString(),
            isLoadingDetails: false,
          ),
        );
      }
    }
  }

  Future<void> _onLoadStudentForEdit(
    LoadStudentForEditEvent event,
    Emitter<StudentManagementState> emit,
  ) async {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;
      emit(
        current.copyWith(
          isFormVisible: true,
          isEditMode: true,
          studentToEdit: event.studentToEdit,
          formStatus: StudentManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }

  void _onShowCreateForm(
    ShowCreateFormEvent event,
    Emitter<StudentManagementState> emit,
  ) {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;
      emit(
        current.copyWith(
          isFormVisible: true,
          isEditMode: false,
          clearStudentToEdit: true,
          formStatus: StudentManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }

  void _onHideForm(HideFormEvent event, Emitter<StudentManagementState> emit) {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;
      emit(
        current.copyWith(
          isFormVisible: false,
          isEditMode: false,
          clearStudentToEdit: true,
          formStatus: StudentManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }

  void _onResetForm(
    ResetFormEvent event,
    Emitter<StudentManagementState> emit,
  ) {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;
      emit(
        current.copyWith(
          formStatus: StudentManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }

  void _onClearFormData(
    ClearFormDataEvent event,
    Emitter<StudentManagementState> emit,
  ) {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;
      emit(
        current.copyWith(
          clearStudentToEdit: true,
          isEditMode: false,
          formStatus: StudentManagementFormStatus.initial,
          clearFormErrorMessage: true,
        ),
      );
    }
  }

  void _onShowStudentDetails(
    ShowStudentDetailsEvent event,
    Emitter<StudentManagementState> emit,
  ) {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;
      emit(
        current.copyWith(
          selectedStudentDetails: event.student,
          isDetailsVisible: true,
          clearDetailsErrorMessage: true,
        ),
      );
    }
  }

  void _onHideStudentDetails(
    HideStudentDetailsEvent event,
    Emitter<StudentManagementState> emit,
  ) {
    if (state is StudentManagementLoaded) {
      final current = state as StudentManagementLoaded;
      emit(
        current.copyWith(
          isDetailsVisible: false,
          clearSelectedStudentDetails: true,
          clearDetailsErrorMessage: true,
        ),
      );
    }
  }
}
