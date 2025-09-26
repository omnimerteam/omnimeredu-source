import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/personnel_entity.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/personnel/dismiss_personnel_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/personnel/get_all_personnel_from_school_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/personnel/update_verified_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/school_admin/update_position_school_admin_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/teaching_assignment/create_teaching_assignment_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/teaching_assignment/delete_teaching_assignment_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/teaching_assignment/get_teaching_assignment_by_teacher_and_school_id_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/teaching_assignment/update_teaching_assignment_usecase.dart';

import 'personnel_management_event.dart';
import 'personnel_management_state.dart';

class PersonnelManagementBloc
    extends Bloc<PersonnelManagementEvent, PersonnelManagementState> {
  final GetAllPersonnelFromSchoolUseCase getAllPersonnelUseCase;
  final CreateTeachingAssignmentUseCase createTeachingAssignmentUseCase;
  final UpdateTeachingAssignmentUseCase updateTeachingAssignmentUseCase;
  final DeleteTeachingAssignmentUseCase deleteTeachingAssignmentUseCase;
  final GetTeachingAssignmentByTeacherAndSchoolIdUseCase
  getTeachingAssignmentByTeacherAndSchoolIdUseCase;
  final UpdateVerifiedUseCase updateVerifiedUseCase;
  final DismissPersonnelUseCase dismissPersonnelUseCase;
  final UpdatePositionSchoolAdminUseCase updatePositionSchoolAdminUseCase;

  PersonnelManagementBloc({
    required this.getAllPersonnelUseCase,
    required this.getTeachingAssignmentByTeacherAndSchoolIdUseCase,
    required this.createTeachingAssignmentUseCase,
    required this.deleteTeachingAssignmentUseCase,
    required this.updateTeachingAssignmentUseCase,
    required this.updateVerifiedUseCase,
    required this.dismissPersonnelUseCase,
    required this.updatePositionSchoolAdminUseCase,
  }) : super(const PersonnelManagementInitial()) {
    // Personnel list events
    on<LoadPersonnelEvent>(_onLoadPersonnel);
    on<RefreshPersonnelEvent>(_onRefreshPersonnel);
    on<LoadMorePersonnelEvent>(_onLoadMorePersonnel);
    on<FilterPersonnelEvent>(_onFilterPersonnel);
    on<SortPersonnelEvent>(_onSortPersonnel);
    on<SearchPersonnelEvent>(_onSearchPersonnel);

    // Personnel detail events
    on<LoadPersonnelByIdEvent>(_onLoadPersonnelById);
    on<ShowPersonnelDetailsEvent>(_onShowPersonnelDetails);
    on<HidePersonnelDetailsEvent>(_onHidePersonnelDetails);

    // Assignment dialog
    on<ShowAssignmentDialogEvent>(_onShowAssignmentDialog);
    on<HideAssignmentDialogEvent>(_onHideAssignmentDialog);

    // TeachingAssignment CRUD
    on<CreateTeachingAssignmentEvent>(_onCreateTeachingAssignment);
    on<UpdateTeachingAssignmentEvent>(_onUpdateTeachingAssignment);
    on<DeleteTeachingAssignmentEvent>(_onDeleteTeachingAssignment);
    on<GetTeachingAssignmentByTeacherAndSchoolEvent>(
      _onGetTeachingAssignmentByTeacherAndSchool,
    );

    // Suspend / Reinstate personnel
    on<UpdatePersonnelStatusEvent>(_onUpdatePersonnelStatus);

    // Dismiss Personnel
    on<DismissPersonnelEvent>(_onDismissPersonnel);
    // Update position for schoolAdmin
    on<UpdateSchoolAdminPositionEvent>(_onUpdateSchoolAdminPosition);
  }

  // =================== Helper ===================
  Future<ApiResponse<List<PersonnelEntity>>> _fetchPersonnel(
    DefaultQueryEntity query,
  ) async {
    final res = await getAllPersonnelUseCase.call(query);
    if (!res.success || res.data == null) {
      throw Exception(res.message ?? "Không thể tải danh sách nhân sự");
    }
    return res;
  }

  /// Helper chuẩn hóa tất cả use case call
  Future<void> _handleUseCaseCall<T>({
    required Future<ApiResponse<T>> Function() call,
    required Emitter<PersonnelManagementState> emit,
    required void Function(
      PersonnelManagementLoaded current,
      ApiResponse<T> res,
    )
    onSuccess,
  }) async {
    if (state is PersonnelManagementLoaded) {
      final current = state as PersonnelManagementLoaded;
      emit(
        current.copyWith(assignmentStatus: PersonnelAssignmentStatus.loading),
      );

      try {
        final res = await call();
        if (res.success) {
          onSuccess(current, res);
        } else {
          emit(
            current.copyWith(
              assignmentStatus: PersonnelAssignmentStatus.error,
              lastActionSuccess: false,
              assignmentErrorMessage: res.message,
            ),
          );
        }
      } catch (e) {
        emit(
          current.copyWith(
            assignmentStatus: PersonnelAssignmentStatus.error,
            lastActionSuccess: false,
            assignmentErrorMessage: e.toString(),
          ),
        );
      }
    }
  }

  // =================== Personnel List ===================
  Future<void> _onLoadPersonnel(
    LoadPersonnelEvent event,
    Emitter<PersonnelManagementState> emit,
  ) async {
    emit(const PersonnelManagementLoading());
    try {
      final query =
          event.query ??
          DefaultQueryEntity(
            sort: [
              {'fullName': 'asc'},
            ],
          );
      final res = await _fetchPersonnel(query);
      emit(
        PersonnelManagementLoaded(
          personnel: res.data!,
          hasReachedMax: res.data!.length < query.limit,
          currentQuery: query,
          message: res.message,
          lastActionSuccess: res.success,
        ),
      );
    } catch (e) {
      emit(PersonnelManagementError(e.toString()));
    }
  }

  Future<void> _onRefreshPersonnel(
    RefreshPersonnelEvent event,
    Emitter<PersonnelManagementState> emit,
  ) async {
    if (state is PersonnelManagementLoaded) {
      final current = state as PersonnelManagementLoaded;
      final refreshedQuery = current.currentQuery.copyWith(page: 1);
      emit(const PersonnelManagementLoading());
      try {
        final res = await _fetchPersonnel(refreshedQuery);
        emit(
          current.copyWith(
            personnel: res.data!,
            hasReachedMax: res.data!.length < refreshedQuery.limit,
            currentQuery: refreshedQuery,
            message: res.message,
            lastActionSuccess: res.success,
          ),
        );
      } catch (e) {
        emit(PersonnelManagementError(e.toString()));
      }
    }
  }

  Future<void> _onLoadMorePersonnel(
    LoadMorePersonnelEvent event,
    Emitter<PersonnelManagementState> emit,
  ) async {
    if (state is PersonnelManagementLoaded) {
      final current = state as PersonnelManagementLoaded;
      if (current.hasReachedMax) return;

      emit(
        PersonnelManagementLoadingMore(
          personnel: current.personnel,
          currentQuery: current.currentQuery,
        ),
      );

      try {
        final nextQuery = current.currentQuery.copyWith(
          page: current.currentQuery.page + 1,
        );
        final res = await _fetchPersonnel(nextQuery);
        emit(
          current.copyWith(
            personnel: [...current.personnel, ...res.data!],
            hasReachedMax: res.data!.length < nextQuery.limit,
            currentQuery: nextQuery,
            message: res.message,
            lastActionSuccess: res.success,
          ),
        );
      } catch (e) {
        emit(PersonnelManagementError(e.toString()));
      }
    }
  }

  Future<void> _reloadWithQuery(
    DefaultQueryEntity newQuery,
    Emitter<PersonnelManagementState> emit,
  ) async {
    emit(const PersonnelManagementLoading());
    try {
      final res = await _fetchPersonnel(newQuery);
      emit(
        PersonnelManagementLoaded(
          personnel: res.data!,
          hasReachedMax: res.data!.length < newQuery.limit,
          currentQuery: newQuery,
          message: res.message,
          lastActionSuccess: res.success,
        ),
      );
    } catch (e) {
      emit(PersonnelManagementError(e.toString()));
    }
  }

  Future<void> _onFilterPersonnel(
    FilterPersonnelEvent event,
    Emitter<PersonnelManagementState> emit,
  ) async {
    if (state is PersonnelManagementLoaded) {
      final current = state as PersonnelManagementLoaded;
      final newQuery = current.currentQuery.copyWith(
        page: 1,
        filter: event.filter,
      );
      await _reloadWithQuery(newQuery, emit);
    }
  }

  Future<void> _onSortPersonnel(
    SortPersonnelEvent event,
    Emitter<PersonnelManagementState> emit,
  ) async {
    if (state is PersonnelManagementLoaded) {
      final current = state as PersonnelManagementLoaded;
      final newQuery = current.currentQuery.copyWith(page: 1, sort: event.sort);
      await _reloadWithQuery(newQuery, emit);
    }
  }

  Future<void> _onSearchPersonnel(
    SearchPersonnelEvent event,
    Emitter<PersonnelManagementState> emit,
  ) async {
    if (state is PersonnelManagementLoaded) {
      final current = state as PersonnelManagementLoaded;
      final newQuery = current.currentQuery.copyWith(
        page: 1,
        search: event.search.trim().isEmpty ? null : event.search.trim(),
      );
      await _reloadWithQuery(newQuery, emit);
    }
  }

  // =================== Personnel Details ===================
  Future<void> _onLoadPersonnelById(
    LoadPersonnelByIdEvent event,
    Emitter<PersonnelManagementState> emit,
  ) async {
    if (state is PersonnelManagementLoaded) {
      final current = state as PersonnelManagementLoaded;
      emit(
        current.copyWith(
          isLoadingDetails: true,
          clearDetailsErrorMessage: true,
        ),
      );

      try {
        final personnelDetails = current.personnel.firstWhere(
          (p) => p.id == event.personnelId,
        );
        emit(
          current.copyWith(
            selectedPersonnelDetails: personnelDetails,
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

  void _onShowPersonnelDetails(
    ShowPersonnelDetailsEvent event,
    Emitter<PersonnelManagementState> emit,
  ) {
    if (state is PersonnelManagementLoaded) {
      final current = state as PersonnelManagementLoaded;
      emit(
        current.copyWith(
          selectedPersonnelDetails: event.personnel,
          isDetailsVisible: true,
          clearDetailsErrorMessage: true,
        ),
      );
    }
  }

  void _onHidePersonnelDetails(
    HidePersonnelDetailsEvent event,
    Emitter<PersonnelManagementState> emit,
  ) {
    if (state is PersonnelManagementLoaded) {
      final current = state as PersonnelManagementLoaded;
      emit(
        current.copyWith(
          isDetailsVisible: false,
          clearSelectedPersonnelDetails: true,
          clearDetailsErrorMessage: true,
        ),
      );
    }
  }

  // =================== Assignment Dialog ===================
  void _onShowAssignmentDialog(
    ShowAssignmentDialogEvent event,
    Emitter<PersonnelManagementState> emit,
  ) {
    if (state is PersonnelManagementLoaded) {
      final current = state as PersonnelManagementLoaded;
      emit(
        current.copyWith(
          selectedPersonnelForAssignment: event.personnel,
          isAssignmentDialogVisible: true,
          assignmentStatus: PersonnelAssignmentStatus.initial,
          clearAssignmentErrorMessage: true,
        ),
      );
    }
  }

  void _onHideAssignmentDialog(
    HideAssignmentDialogEvent event,
    Emitter<PersonnelManagementState> emit,
  ) {
    if (state is PersonnelManagementLoaded) {
      final current = state as PersonnelManagementLoaded;
      emit(
        current.copyWith(
          isAssignmentDialogVisible: false,
          clearSelectedPersonnelForAssignment: true,
          assignmentStatus: PersonnelAssignmentStatus.initial,
          clearAssignmentErrorMessage: true,
        ),
      );
    }
  }

  // =================== TeachingAssignment CRUD ===================
  Future<void> _onCreateTeachingAssignment(
    CreateTeachingAssignmentEvent event,
    Emitter<PersonnelManagementState> emit,
  ) async {
    await _handleUseCaseCall(
      call: () => createTeachingAssignmentUseCase.call(event.assignment),
      emit: emit,
      onSuccess: (current, res) {
        emit(
          current.copyWith(
            assignmentStatus: PersonnelAssignmentStatus.success,
            lastActionSuccess: true,
            assignmentErrorMessage: null,
            isAssignmentDialogVisible: false,
            clearSelectedPersonnelForAssignment: true,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateTeachingAssignment(
    UpdateTeachingAssignmentEvent event,
    Emitter<PersonnelManagementState> emit,
  ) async {
    await _handleUseCaseCall(
      call: () => updateTeachingAssignmentUseCase.call(event.assignment),
      emit: emit,
      onSuccess: (current, res) {
        emit(
          current.copyWith(
            assignmentStatus: PersonnelAssignmentStatus.success,
            lastActionSuccess: true,
            assignmentErrorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteTeachingAssignment(
    DeleteTeachingAssignmentEvent event,
    Emitter<PersonnelManagementState> emit,
  ) async {
    await _handleUseCaseCall(
      call: () => deleteTeachingAssignmentUseCase.call(event.assignmentId),
      emit: emit,
      onSuccess: (current, res) {
        emit(
          current.copyWith(
            assignmentStatus: PersonnelAssignmentStatus.success,
            lastActionSuccess: true,
            assignmentErrorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> _onGetTeachingAssignmentByTeacherAndSchool(
    GetTeachingAssignmentByTeacherAndSchoolEvent event,
    Emitter<PersonnelManagementState> emit,
  ) async {
    await _handleUseCaseCall(
      call: () => getTeachingAssignmentByTeacherAndSchoolIdUseCase.call(
        event.teacherId,
        event.schoolId,
      ),
      emit: emit,
      onSuccess: (current, res) {
        emit(
          current.copyWith(
            assignmentStatus: PersonnelAssignmentStatus.success,
            lastActionSuccess: true,
            assignmentErrorMessage: null,
            currentTeachingAssignment: res.data,
          ),
        );
      },
    );
  }

  // =================== Suspend / Reinstate ===================
  Future<void> _onUpdatePersonnelStatus(
    UpdatePersonnelStatusEvent event,
    Emitter<PersonnelManagementState> emit,
  ) async {
    if (state is PersonnelManagementLoaded) {
      final current = state as PersonnelManagementLoaded;

      emit(
        current.copyWith(assignmentStatus: PersonnelAssignmentStatus.loading),
      );

      await _handleUseCaseCall(
        call: () =>
            updateVerifiedUseCase.call(event.personnelId, event.isVerified),
        emit: emit,
        onSuccess: (current, res) {
          final updatedList = current.personnel.map((p) {
            if (p.id == event.personnelId) {
              return p.copyWith(isVerified: event.isVerified);
            }
            return p;
          }).toList();

          emit(
            current.copyWith(
              personnel: updatedList,
              lastActionSuccess: true,
              message: event.isVerified
                  ? 'Khôi phục công tác thành công'
                  : 'Đình chỉ công tác thành công',
              assignmentStatus: PersonnelAssignmentStatus.success,
            ),
          );
        },
      );
    }
  }

  Future<void> _onDismissPersonnel(
    DismissPersonnelEvent event,
    Emitter<PersonnelManagementState> emit,
  ) async {
    if (state is PersonnelManagementLoaded) {
      final current = state as PersonnelManagementLoaded;

      // hiển thị loading trên assignmentStatus để đồng bộ với các action khác
      emit(
        current.copyWith(assignmentStatus: PersonnelAssignmentStatus.loading),
      );

      try {
        final res = await dismissPersonnelUseCase.call(event.personnel.id!);
        if (res.success) {
          // Cập nhật danh sách nhân sự: remove nhân sự vừa bị đuổi việc
          final updatedList = current.personnel
              .where((p) => p.id != event.personnel.id)
              .toList();

          emit(
            current.copyWith(
              personnel: updatedList,
              lastActionSuccess: true,
              message:
                  res.message ??
                  'Đuổi việc thành công "${event.personnel.fullName}"',
              assignmentStatus: PersonnelAssignmentStatus.success,
            ),
          );
        } else {
          emit(
            current.copyWith(
              lastActionSuccess: false,
              message: res.message ?? 'Đuổi việc thất bại',
              assignmentStatus: PersonnelAssignmentStatus.error,
            ),
          );
        }
      } catch (e) {
        emit(
          current.copyWith(
            lastActionSuccess: false,
            message: e.toString(),
            assignmentStatus: PersonnelAssignmentStatus.error,
          ),
        );
      }
    }
  }

  Future<void> _onUpdateSchoolAdminPosition(
    UpdateSchoolAdminPositionEvent event,
    Emitter<PersonnelManagementState> emit,
  ) async {
    if (state is PersonnelManagementLoaded) {
      final current = state as PersonnelManagementLoaded;

      emit(
        current.copyWith(assignmentStatus: PersonnelAssignmentStatus.loading),
      );

      try {
        final res = await updatePositionSchoolAdminUseCase.call(
          event.personnelId,
          event.position,
        );

        if (res.success && res.data != null) {
          // Cập nhật danh sách nhân sự
          final updatedList = current.personnel.map((p) {
            if (p.id == event.personnelId) {
              return p.copyWith(position: event.position);
            }
            return p;
          }).toList();

          emit(
            current.copyWith(
              personnel: updatedList,
              lastActionSuccess: true,
              message: 'Cập nhật chức vụ thành công',
              assignmentStatus: PersonnelAssignmentStatus.success,
            ),
          );
        } else {
          emit(
            current.copyWith(
              lastActionSuccess: false,
              message: res.message ?? 'Cập nhật chức vụ thất bại',
              assignmentStatus: PersonnelAssignmentStatus.error,
            ),
          );
        }
      } catch (e) {
        emit(
          current.copyWith(
            lastActionSuccess: false,
            message: e.toString(),
            assignmentStatus: PersonnelAssignmentStatus.error,
          ),
        );
      }
    }
  }
}
