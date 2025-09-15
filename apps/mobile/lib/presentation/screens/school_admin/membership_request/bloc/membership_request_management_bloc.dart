import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/core/app_constants.dart';
import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/membership_request/get_all_membership_request_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/membership_request/update_status_membership_request_usecase.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/bloc/membership_request_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/membership_request/bloc/membership_request_management_state.dart';

class MembershipRequestManagementBloc
    extends
        Bloc<
          MembershipRequestManagementEvent,
          MembershipRequestManagementState
        > {
  final GetAllMembershipRequestsUseCase getAllMembershipRequests;
  final UpdateStatusMembershipRequestUseCase updateStatusMembershipRequest;

  MembershipRequestManagementBloc({
    required this.getAllMembershipRequests,
    required this.updateStatusMembershipRequest,
  }) : super(const MembershipRequestInitial()) {
    on<LoadMembershipRequestsEvent>(_onLoadMembershipRequests);
    on<RefreshMembershipRequestsEvent>(_onRefreshMembershipRequests);
    on<LoadMoreMembershipRequestsEvent>(_onLoadMoreMembershipRequests);
    on<FilterMembershipRequestsEvent>(_onFilterMembershipRequests);
    on<SortMembershipRequestsEvent>(_onSortMembershipRequests);
    on<UpdateStatusEvent>(_onUpdateStatus);
  }

  Future<void> _onLoadMembershipRequests(
    LoadMembershipRequestsEvent event,
    Emitter<MembershipRequestManagementState> emit,
  ) async {
    emit(const MembershipRequestLoading());

    try {
      final defaultSort = <String, String>{"createdAt": "desc"};
      final requests = await getAllMembershipRequests.call(
        page: AppConstants.defaultPage,
        limit: AppConstants.defaultLimit,
        sort: defaultSort,
      );

      emit(
        MembershipRequestLoaded(
          requests: requests,
          hasReachedMax: requests.length < AppConstants.defaultLimit,
          currentPage: AppConstants.defaultPage,
          currentSort: defaultSort,
          currentFilter: {},
        ),
      );
    } catch (error) {
      emit(MembershipRequestError(error.toString()));
    }
  }

  Future<void> _onRefreshMembershipRequests(
    RefreshMembershipRequestsEvent event,
    Emitter<MembershipRequestManagementState> emit,
  ) async {
    if (state is MembershipRequestLoaded) {
      final currentState = state as MembershipRequestLoaded;

      try {
        final requests = await getAllMembershipRequests.call(
          page: AppConstants.defaultPage,
          limit: AppConstants.defaultLimit,
          sort: currentState.currentSort,
          filter: currentState.currentFilter,
        );

        emit(
          currentState.copyWith(
            requests: requests,
            hasReachedMax: requests.length < AppConstants.defaultLimit,
            currentPage: AppConstants.defaultPage,
          ),
        );
      } catch (error) {
        emit(MembershipRequestError(error.toString()));
      }
    }
  }

  Future<void> _onLoadMoreMembershipRequests(
    LoadMoreMembershipRequestsEvent event,
    Emitter<MembershipRequestManagementState> emit,
  ) async {
    if (state is MembershipRequestLoaded) {
      final currentState = state as MembershipRequestLoaded;

      if (currentState.hasReachedMax) return;

      emit(
        MembershipRequestLoadingMore(
          requests: currentState.requests,
          currentSort: currentState.currentSort,
          currentFilter: currentState.currentFilter,
        ),
      );

      try {
        final nextPage = currentState.currentPage + 1;
        final newRequests = await getAllMembershipRequests.call(
          page: nextPage,
          limit: AppConstants.defaultLimit,
          sort: currentState.currentSort,
          filter: currentState.currentFilter,
        );

        emit(
          currentState.copyWith(
            requests: [...currentState.requests, ...newRequests],
            hasReachedMax: newRequests.length < AppConstants.defaultLimit,
            currentPage: nextPage,
          ),
        );
      } catch (error) {
        emit(MembershipRequestError(error.toString()));
      }
    }
  }

  Future<void> _onFilterMembershipRequests(
    FilterMembershipRequestsEvent event,
    Emitter<MembershipRequestManagementState> emit,
  ) async {
    if (state is MembershipRequestLoaded) {
      final currentState = state as MembershipRequestLoaded;

      emit(const MembershipRequestLoading());

      try {
        final requests = await getAllMembershipRequests.call(
          page: AppConstants.defaultPage,
          limit: AppConstants.defaultLimit,
          sort: currentState.currentSort,
          filter: event.filter,
        );

        emit(
          currentState.copyWith(
            requests: requests,
            hasReachedMax: requests.length < AppConstants.defaultLimit,
            currentPage: AppConstants.defaultPage,
            currentFilter: event.filter,
          ),
        );
      } catch (error) {
        emit(MembershipRequestError(error.toString()));
      }
    }
  }

  Future<void> _onSortMembershipRequests(
    SortMembershipRequestsEvent event,
    Emitter<MembershipRequestManagementState> emit,
  ) async {
    if (state is MembershipRequestLoaded) {
      final currentState = state as MembershipRequestLoaded;

      emit(const MembershipRequestLoading());

      try {
        final requests = await getAllMembershipRequests.call(
          page: AppConstants.defaultPage,
          limit: AppConstants.defaultLimit,
          sort: event.sort,
          filter: currentState.currentFilter,
        );

        emit(
          currentState.copyWith(
            requests: requests,
            hasReachedMax: requests.length < AppConstants.defaultLimit,
            currentPage: AppConstants.defaultPage,
            currentSort: event.sort,
          ),
        );
      } catch (error) {
        emit(MembershipRequestError(error.toString()));
      }
    }
  }

  Future<void> _onUpdateStatus(
    UpdateStatusEvent event,
    Emitter<MembershipRequestManagementState> emit,
  ) async {
    if (state is MembershipRequestLoaded) {
      final currentState = state as MembershipRequestLoaded;

      emit(
        MembershipRequestUpdatingStatus(
          requests: currentState.requests,
          updatingRequestId: event.requestId,
        ),
      );

      try {
        final updatedRequest = await updateStatusMembershipRequest.call(
          event.requestId,
          event.newStatus,
        );

        final updatedRequests = currentState.requests.map((request) {
          if (request.id == event.requestId) {
            return MembershipRequestEntity(
              id: updatedRequest.id,
              userId: updatedRequest.userId,
              schoolId: updatedRequest.schoolId,
              classId: updatedRequest.classId,
              role: updatedRequest.role,
              action: updatedRequest.action,
              status: updatedRequest.status,
              note: updatedRequest.note,
              createdAt: updatedRequest.createdAt,
              updatedAt: updatedRequest.updatedAt,
            );
          }
          return request;
        }).toList();

        emit(currentState.copyWith(requests: updatedRequests));
      } catch (error) {
        emit(MembershipRequestError(error.toString()));
      }
    }
  }
}
