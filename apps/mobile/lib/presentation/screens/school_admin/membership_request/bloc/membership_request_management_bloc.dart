import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/membership_request/get_all_membership_request_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/membership_request/update_status_membership_request_usecase.dart';
import 'membership_request_management_event.dart';
import 'membership_request_management_state.dart';

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
    on<LoadMembershipRequestsEvent>(_onLoadRequests);
    on<RefreshMembershipRequestsEvent>(_onRefreshRequests);
    on<LoadMoreMembershipRequestsEvent>(_onLoadMoreRequests);
    on<FilterMembershipRequestsEvent>(_onFilterRequests);
    on<SortMembershipRequestsEvent>(_onSortRequests);
    on<UpdateStatusEvent>(_onUpdateStatus);
  }

  Future<void> _onLoadRequests(
    LoadMembershipRequestsEvent event,
    Emitter<MembershipRequestManagementState> emit,
  ) async {
    emit(const MembershipRequestLoading());

    try {
      final query =
          event.query ??
          DefaultQueryEntity(
            page: 1,
            limit: 10,
            sort: [
              {"createdAt": "desc"},
            ],
            filter: {},
          );

      final requests = await getAllMembershipRequests.call(query);

      emit(
        MembershipRequestLoaded(
          requests: requests,
          hasReachedMax: requests.length < query.limit,
          currentQuery: query,
        ),
      );
    } catch (error) {
      emit(MembershipRequestError(error.toString()));
    }
  }

  Future<void> _onRefreshRequests(
    RefreshMembershipRequestsEvent event,
    Emitter<MembershipRequestManagementState> emit,
  ) async {
    if (state is MembershipRequestLoaded) {
      final current = state as MembershipRequestLoaded;

      try {
        final refreshedQuery = current.currentQuery.copyWith(page: 1);
        final requests = await getAllMembershipRequests.call(refreshedQuery);

        emit(
          current.copyWith(
            requests: requests,
            hasReachedMax: requests.length < refreshedQuery.limit,
            currentQuery: refreshedQuery,
          ),
        );
      } catch (error) {
        emit(MembershipRequestError(error.toString()));
      }
    }
  }

  Future<void> _onLoadMoreRequests(
    LoadMoreMembershipRequestsEvent event,
    Emitter<MembershipRequestManagementState> emit,
  ) async {
    if (state is MembershipRequestLoaded) {
      final current = state as MembershipRequestLoaded;
      if (current.hasReachedMax) return;

      emit(
        MembershipRequestLoadingMore(
          requests: current.requests,
          currentQuery: current.currentQuery,
        ),
      );

      try {
        final nextQuery = current.currentQuery.copyWith(
          page: current.currentQuery.page + 1,
        );
        final newRequests = await getAllMembershipRequests.call(nextQuery);

        emit(
          current.copyWith(
            requests: [...current.requests, ...newRequests],
            hasReachedMax: newRequests.length < nextQuery.limit,
            currentQuery: nextQuery,
          ),
        );
      } catch (error) {
        emit(MembershipRequestError(error.toString()));
      }
    }
  }

  Future<void> _onFilterRequests(
    FilterMembershipRequestsEvent event,
    Emitter<MembershipRequestManagementState> emit,
  ) async {
    if (state is MembershipRequestLoaded) {
      final current = state as MembershipRequestLoaded;

      emit(const MembershipRequestLoading());

      try {
        final newQuery = current.currentQuery.copyWith(
          page: 1,
          filter: event.filter,
        );
        final requests = await getAllMembershipRequests.call(newQuery);

        emit(
          current.copyWith(
            requests: requests,
            hasReachedMax: requests.length < newQuery.limit,
            currentQuery: newQuery,
          ),
        );
      } catch (error) {
        emit(MembershipRequestError(error.toString()));
      }
    }
  }

  Future<void> _onSortRequests(
    SortMembershipRequestsEvent event,
    Emitter<MembershipRequestManagementState> emit,
  ) async {
    if (state is MembershipRequestLoaded) {
      final current = state as MembershipRequestLoaded;

      emit(const MembershipRequestLoading());

      try {
        final newQuery = current.currentQuery.copyWith(
          page: 1,
          sort: [event.sort],
        );
        final requests = await getAllMembershipRequests.call(newQuery);

        emit(
          current.copyWith(
            requests: requests,
            hasReachedMax: requests.length < newQuery.limit,
            currentQuery: newQuery,
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
      final current = state as MembershipRequestLoaded;

      emit(
        MembershipRequestFormLoading(
          requests: current.requests,
          currentQuery: current.currentQuery,
          isFormVisible: current.isFormVisible,
        ),
      );

      try {
        final newStatus = await updateStatusMembershipRequest.call(
          event.requestId,
          event.newStatus,
        );

        final updatedRequests = current.requests
            .map(
              (r) =>
                  r.id == event.requestId ? r.copyWith(status: newStatus) : r,
            )
            .toList();

        emit(
          current.copyWith(
            requests: updatedRequests,
            formStatus: MembershipRequestFormStatus.success,
            isFormVisible: false,
          ),
        );
      } catch (error) {
        emit(
          current.copyWith(
            formStatus: MembershipRequestFormStatus.error,
            formErrorMessage: error.toString(),
          ),
        );
      }
    }
  }
}
