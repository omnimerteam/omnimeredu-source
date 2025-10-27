import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/extra_fee/create_extra_fee_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/extra_fee/delete_extra_fee_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/extra_fee/get_all_extra_fee_usecase.dart';
import 'package:flutter_ios_android_platforms/domain/usecases/extra_fee/update_extra_fee_usecase.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/tuition/extra_fee/bloc/extra_fee_management_event.dart';
import 'package:flutter_ios_android_platforms/presentation/screens/school_admin/tuition/extra_fee/bloc/extra_fee_management_state.dart';

class ExtraFeeManagementBloc
    extends Bloc<ExtraFeeManagementEvent, ExtraFeeManagementState> {
  final GetAllExtraFeeUseCase getAllExtraFeeUseCase;
  final CreateExtraFeeUseCase createExtraFeeUseCase;
  final UpdateExtraFeeUseCase updateExtraFeeUseCase;
  final DeleteExtraFeeUseCase deleteExtraFeeUseCase;

  ExtraFeeManagementBloc({
    required this.getAllExtraFeeUseCase,
    required this.createExtraFeeUseCase,
    required this.updateExtraFeeUseCase,
    required this.deleteExtraFeeUseCase,
  }) : super(const ExtraFeeManagementInitial()) {
    on<LoadExtraFeeEvent>(_onLoadExtraFee);
    on<LoadMoreExtraFeeEvent>(_onLoadMoreExtraFee);

    // NEW: thêm các handler filter / sort / search
    on<FilterExtraFeeEvent>(_onFilterExtraFee);
    on<SortExtraFeeEvent>(_onSortExtraFee);
    on<SearchExtraFeeEvent>(_onSearchExtraFee);

    // CRUD
    on<CreateExtraFeeEvent>(_onCreateExtraFee);
    on<UpdateExtraFeeEvent>(_onUpdateExtraFee);
    on<DeleteExtraFeeEvent>(_onDeleteExtraFee);

    // Details
    on<ShowExtraFeeDetailsEvent>(_onShowDetails);
    on<HideExtraFeeDetailsEvent>(_onHideDetails);
  }

  /// --- Lấy danh sách phí phụ ---
  Future<void> _onLoadExtraFee(
    LoadExtraFeeEvent event,
    Emitter<ExtraFeeManagementState> emit,
  ) async {
    emit(const ExtraFeeManagementLoading());

    final res = await getAllExtraFeeUseCase(
      event.query ??
          DefaultQueryEntity(
            sort: [
              {'name': 'asc'},
            ],
          ),
    );

    if (res.success) {
      emit(
        ExtraFeeManagementLoaded(
          extraFees: res.data!,
          hasReachedMax: res.data!.isEmpty,
          currentQuery: event.query ?? DefaultQueryEntity(),
          status: ExtraFeeStatus.success,
        ),
      );
    } else {
      emit(ExtraFeeManagementError(res.message ?? ""));
    }
  }

  /// --- Load thêm (phân trang) ---
  Future<void> _onLoadMoreExtraFee(
    LoadMoreExtraFeeEvent event,
    Emitter<ExtraFeeManagementState> emit,
  ) async {
    if (state is! ExtraFeeManagementLoaded) return;
    final currentState = state as ExtraFeeManagementLoaded;
    if (currentState.hasReachedMax) return;

    final nextQuery = currentState.currentQuery.copyWith(
      page: currentState.currentQuery.page + 1,
    );

    final res = await getAllExtraFeeUseCase(nextQuery);

    if (res.success && res.data != null) {
      if (res.data!.isEmpty) {
        emit(currentState.copyWith(hasReachedMax: true));
      } else {
        emit(
          currentState.copyWith(
            extraFees: [...currentState.extraFees, ...res.data!],
            currentQuery: nextQuery,
          ),
        );
      }
    } else {
      emit(ExtraFeeManagementError(res.message ?? ""));
    }
  }

  /// --- Lọc ---
  Future<void> _onFilterExtraFee(
    FilterExtraFeeEvent event,
    Emitter<ExtraFeeManagementState> emit,
  ) async {
    emit(const ExtraFeeManagementLoading());
    final query = DefaultQueryEntity(filter: event.filter);

    final res = await getAllExtraFeeUseCase(query);

    if (res.success) {
      emit(
        ExtraFeeManagementLoaded(
          extraFees: res.data!,
          hasReachedMax: res.data!.isEmpty,
          currentQuery: query,
          status: ExtraFeeStatus.success,
        ),
      );
    } else {
      emit(ExtraFeeManagementError(res.message ?? ""));
    }
  }

  /// --- Sắp xếp ---
  Future<void> _onSortExtraFee(
    SortExtraFeeEvent event,
    Emitter<ExtraFeeManagementState> emit,
  ) async {
    emit(const ExtraFeeManagementLoading());

    final query = DefaultQueryEntity(sort: event.sort);
    final res = await getAllExtraFeeUseCase(query);

    if (res.success) {
      emit(
        ExtraFeeManagementLoaded(
          extraFees: res.data!,
          hasReachedMax: res.data!.isEmpty,
          currentQuery: query,
          status: ExtraFeeStatus.success,
        ),
      );
    } else {
      emit(ExtraFeeManagementError(res.message ?? ""));
    }
  }

  /// --- Tìm kiếm ---
  Future<void> _onSearchExtraFee(
    SearchExtraFeeEvent event,
    Emitter<ExtraFeeManagementState> emit,
  ) async {
    emit(const ExtraFeeManagementLoading());

    final query = DefaultQueryEntity(search: event.search);

    final res = await getAllExtraFeeUseCase(query);

    if (res.success) {
      emit(
        ExtraFeeManagementLoaded(
          extraFees: res.data!,
          hasReachedMax: res.data!.isEmpty,
          currentQuery: query,
          status: ExtraFeeStatus.success,
        ),
      );
    } else {
      emit(ExtraFeeManagementError(res.message ?? ""));
    }
  }

  /// --- Thêm mới ---
  Future<void> _onCreateExtraFee(
    CreateExtraFeeEvent event,
    Emitter<ExtraFeeManagementState> emit,
  ) async {
    if (state is! ExtraFeeManagementLoaded) return;
    final currentState = state as ExtraFeeManagementLoaded;

    emit(currentState.copyWith(status: ExtraFeeStatus.loading));

    final res = await createExtraFeeUseCase(event.extraFee);

    if (res.success && res.data != null) {
      final updatedList = [res.data!, ...currentState.extraFees];
      emit(
        currentState.copyWith(
          extraFees: updatedList,
          status: ExtraFeeStatus.success,
          message: "Tạo phí phụ thành công",
        ),
      );
    } else {
      emit(
        currentState.copyWith(
          status: ExtraFeeStatus.error,
          message: res.message,
        ),
      );
    }
  }

  /// --- Cập nhật ---
  Future<void> _onUpdateExtraFee(
    UpdateExtraFeeEvent event,
    Emitter<ExtraFeeManagementState> emit,
  ) async {
    if (state is! ExtraFeeManagementLoaded) return;
    final currentState = state as ExtraFeeManagementLoaded;

    emit(currentState.copyWith(status: ExtraFeeStatus.loading));

    final res = await updateExtraFeeUseCase(event.extraFee);

    if (res.success && res.data != null) {
      final updatedFee = res.data!;
      final updatedList = currentState.extraFees.map((fee) {
        return fee.id == updatedFee.id ? updatedFee : fee;
      }).toList();

      emit(
        currentState.copyWith(
          extraFees: updatedList,
          status: ExtraFeeStatus.success,
          message: "Cập nhật thành công",
          selectedExtraFee: updatedFee,
        ),
      );
    } else {
      emit(
        currentState.copyWith(
          status: ExtraFeeStatus.error,
          message: res.message,
        ),
      );
    }
  }

  /// --- Xóa ---
  Future<void> _onDeleteExtraFee(
    DeleteExtraFeeEvent event,
    Emitter<ExtraFeeManagementState> emit,
  ) async {
    if (state is! ExtraFeeManagementLoaded) return;
    final currentState = state as ExtraFeeManagementLoaded;

    emit(currentState.copyWith(status: ExtraFeeStatus.loading));

    final res = await deleteExtraFeeUseCase(event.feeId);

    if (res.success) {
      final updatedList = currentState.extraFees
          .where((fee) => fee.id != event.feeId)
          .toList();

      emit(
        currentState.copyWith(
          extraFees: updatedList,
          status: ExtraFeeStatus.success,
          message: "Đã xóa thành công",
        ),
      );
    } else {
      emit(
        currentState.copyWith(
          status: ExtraFeeStatus.error,
          message: res.message,
        ),
      );
    }
  }

  /// --- Hiện/ẩn chi tiết ---
  void _onShowDetails(
    ShowExtraFeeDetailsEvent event,
    Emitter<ExtraFeeManagementState> emit,
  ) {
    if (state is! ExtraFeeManagementLoaded) return;
    final currentState = state as ExtraFeeManagementLoaded;

    emit(
      currentState.copyWith(
        selectedExtraFee: event.extraFee,
        isDetailsVisible: true,
      ),
    );
  }

  void _onHideDetails(
    HideExtraFeeDetailsEvent event,
    Emitter<ExtraFeeManagementState> emit,
  ) {
    if (state is! ExtraFeeManagementLoaded) return;
    final currentState = state as ExtraFeeManagementLoaded;

    emit(
      currentState.copyWith(selectedExtraFee: null, isDetailsVisible: false),
    );
  }
}
